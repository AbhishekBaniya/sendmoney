import '../../../core/error/failures.dart';
import '../../../core/network/endpoints.dart';
import '../../domain/entities/portfolio_entity.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../data_source/remote_data_source/portfolio_remote_data_source.dart';
import 'package:dartz/dartz.dart';

class PortfolioRepositoryImpl implements PortfolioRepository {
  final PortfolioRemoteDataSource remoteDataSource;

  PortfolioRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<PortfolioEntity>>> getPortfolio() async {
    try {
      final portfolioModels = await remoteDataSource.getPortfolio(endPoint: EndPoints.user);
      return Right(portfolioModels.map((model) => PortfolioEntity(
        id: model.id, name: model.name, username: model.username, email: model.email, phone: model.phone, website: model.website,
          /*title: model.title,
          description: model.description*/),).toList(growable: false,));
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
