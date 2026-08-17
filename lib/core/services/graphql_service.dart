import 'package:almasry_2/core/constants/app_api.dart';
import 'package:almasry_2/core/constants/app_stores.dart';
import 'package:almasry_2/core/localization/app_locale.dart';
import 'package:graphql/client.dart';

class GraphQLServiceException implements Exception {
  final String message;

  const GraphQLServiceException(this.message);

  @override
  String toString() => message;
}

class GraphQLService {
  late final GraphQLClient _client;

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
    final QueryResult result = await _client.query(
      QueryOptions(
        document: gql(document),
        variables: variables,
        fetchPolicy: FetchPolicy.networkOnly,
        context: _contextFor(headers),
      ),
    );

    return _resolve(result);
  }

  Context _contextFor(Map<String, String> headers) {
    final Map<String, String> resolved = {
      AppStores.header: AppLocale.storeCode,
      ...headers,
    };

    return const Context().withEntry(HttpLinkHeaders(headers: resolved));
  }

  Future<Map<String, dynamic>> mutate(
    String document, {
    Map<String, dynamic> variables = const {},
    Map<String, String> headers = const {},
  }) async {
    final QueryResult result = await _client.mutate(
      MutationOptions(
        document: gql(document),
        variables: variables,
        fetchPolicy: FetchPolicy.noCache,
        context: _contextFor(headers),
      ),
    );

    return _resolve(result);
  }

  Map<String, dynamic> _resolve(QueryResult result) {
    if (result.hasException) {
      throw GraphQLServiceException(_extractMessage(result.exception!));
    }

    final Map<String, dynamic>? data = result.data;

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
