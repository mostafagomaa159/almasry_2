import 'package:almasry_2/core/constants/app_api.dart';
import 'package:almasry_2/core/services/network_logger_service.dart';
import 'package:graphql/client.dart';

class GraphQLServiceException implements Exception {
  final String message;

  const GraphQLServiceException(this.message);

  @override
  String toString() => message;
}


class _LoggedCall {
  const _LoggedCall(this.label, this.stopwatch);

  final String label;
  final Stopwatch stopwatch;
}

class GraphQLService {
  late final GraphQLClient _client;


  static const NetworkLoggerService _logger = NetworkLoggerService();

  GraphQLService() {
    _client = GraphQLClient(
      link: HttpLink(ApiConstants.graphqlUrl),
      cache: GraphQLCache(),
    );
  }


  Future<Map<String, dynamic>> query(
    String document, {
    Map<String, dynamic> variables = const {},
    Map<String, String> headers = const {},
  }) async {
    final _LoggedCall call = _logRequest(
      'QUERY',
      document,
      variables,
      headers,
    );

    final QueryResult result = await _client.query(
      QueryOptions(
        document: gql(document),
        variables: variables,
        fetchPolicy: FetchPolicy.noCache,
        context: _contextFor(headers),
      ),
    );

    return _resolve(result, call);
  }


  Context _contextFor(Map<String, String> headers) {
    if (headers.isEmpty) return const Context();

    return const Context().withEntry(HttpLinkHeaders(headers: headers));
  }

  Future<Map<String, dynamic>> mutate(
    String document, {
    Map<String, dynamic> variables = const {},
  }) async {
    final _LoggedCall call = _logRequest(
      'MUTATION',
      document,
      variables,
      const {},
    );

    final QueryResult result = await _client.mutate(
      MutationOptions(
        document: gql(document),
        variables: variables,
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    return _resolve(result, call);
  }


  _LoggedCall _logRequest(
    String kind,
    String document,
    Map<String, dynamic> variables,
    Map<String, String> headers,
  ) {
    final String label =
        '$kind ${NetworkLoggerService.operationName(document) ?? 'anonymous'}';

    _logger.open('GRAPHQL $label');

    if (headers.isNotEmpty) {
      _logger.line('headers:');
      headers.forEach(_logger.keyValue);
    }

    if (variables.isNotEmpty) {
      _logger.section('variables', variables);
    }

    _logger.close();

    return _LoggedCall(label, Stopwatch()..start());
  }

  Map<String, dynamic> _resolve(QueryResult result, _LoggedCall call) {
    final String elapsed = ' (${call.stopwatch.elapsedMilliseconds}ms)';

    if (result.hasException) {
      final String message = _extractMessage(result.exception!);

      _logger.open('GRAPHQL ERROR ${call.label}$elapsed');
      _logger.line(message.isEmpty ? '${result.exception}' : message);


      if (result.data != null) {
        _logger.section('partial data', result.data);
      }

      _logger.close();

      throw GraphQLServiceException(message);
    }

    final Map<String, dynamic>? data = result.data;

    _logger.open('GRAPHQL REPLY ${call.label}$elapsed');
    _logger.section('data', data);
    _logger.close();

    if (data == null) {
      throw const GraphQLServiceException('');
    }

    return data;
  }

  String _extractMessage(OperationException exception) {
    if (exception.graphqlErrors.isNotEmpty) {
      final String message = exception.graphqlErrors.first.message;

      if (message.trim().isNotEmpty) {
        return message;
      }
    }

    final LinkException? linkException = exception.linkException;

    if (linkException != null) {
      final dynamic originalException = linkException.originalException;

      if (originalException != null) {
        return originalException.toString();
      }

      return linkException.toString();
    }

    return '';
  }
}
