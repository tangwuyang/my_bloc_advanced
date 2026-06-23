import '../errors/app_error.dart';

sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;

  bool get isFailure => this is Failure<T>;

  T? get dataOrNull =>
      switch(this){
        Success(:final data) => data,
        Failure() => null,
      };
}

final class Success<T> extends Result<T> {
  const Success(this.data);   //父构造器不是常量的方法 子构造器就不能用常量构造方法  给Result构造器的const去掉就会报错

  final T data;

  @override
  bool operator ==(Object other) => other is Success<T> && other.data == data;

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => 'Success($data)';
}

final class Failure<T> extends Result<T> {
  const Failure(this.error, {this.stackTrace});
  final AppError error;
  final StackTrace? stackTrace;

  @override
  bool operator ==(Object other) => other is Failure<T> && other.error == error;

  @override
  int get hashCode => error.hashCode;

  @override
  String toString() => 'Failure($error)';
}