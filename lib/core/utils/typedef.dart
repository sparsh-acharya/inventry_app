import 'package:dartz/dartz.dart';
import 'package:inventry_app/core/errors/failure.dart';

typedef FutureEither<T> = Future<Either<Failure,T>>;
typedef FutureVoid = FutureEither<void>;
