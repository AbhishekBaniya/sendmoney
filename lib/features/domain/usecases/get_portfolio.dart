import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/utils/app_logger.dart';
import '../repositories/portfolio_repository.dart';
import '../entities/portfolio_entity.dart';

/*class GetPortfolio {
  final PortfolioRepository repository;

  GetPortfolio(this.repository);

  Future<Either<Failure, List<PortfolioEntity>>> call() async {
    return await repository.getPortfolio();
  }
}*/

class GetPortfolio {
  final PortfolioRepository repository;

  // Constructor to inject the repository dependency
  GetPortfolio(this.repository);

  /// Fetches a portfolio, returning either a [Failure] or a list of [PortfolioEntity].
  Future<Either<Failure, List<PortfolioEntity>>> call() async {
    try {
      // Attempt to fetch the portfolio from the repository
      return await repository.getPortfolio();
    } catch (e, stackTrace) {
      // Log the error and stack trace for debugging purposes
      Logger().error('Error in GetPortfolio call: $e');
      Logger().info('StackTrace: $stackTrace');

      // Return a generic Failure to the caller
      return Left(ServerFailure('Unable to fetch portfolio'));
    }
  }
}

