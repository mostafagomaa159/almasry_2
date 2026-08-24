import 'package:almasry_2/core/constants/app_api.dart';
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

  /// Pass [headers] to override the request headers for this call only —
  /// Magento's `store` header is what selects the Arabic or English store
  /// view, so a search may need to hit both.
  ///
  /// [FetchPolicy.noCache], not `networkOnly`: both always hit the network, but
  /// `networkOnly` also writes the reply into the normalized cache and hands
  /// back a *re-read* of it. Nothing in this app ever reads that cache, and the
  /// round trip actively breaks the cart.
  ///
  /// Two queries selecting the same entity with different fields is enough to
  /// do it. `getCartDetails` selects `Cart.id`, so the cart normalizes to
  /// `Cart:<masked-id>` with a `shipping_addresses` list that has no
  /// `available_shipping_methods` in it. `getCartShippingMethods` then selects
  /// `cart` *without* `id`, so on re-read the resolver walks back to that same
  /// stored entity, finds the field missing, and the whole read comes back null
  /// as `CacheMissException: Round trip cache re-read failed`. Skipping
  /// normalization returns the server's own reply and removes the failure mode.
  Future<Map<String, dynamic>> query(
    String document, {
    Map<String, dynamic> variables = const {},
    Map<String, String> headers = const {},
  }) async {
    final QueryResult result = await _client.query(
      QueryOptions(
        document: gql(document),
        variables: variables,
        fetchPolicy: FetchPolicy.noCache,
        context: _contextFor(headers),
      ),
    );

    return _resolve(result);
  }

  /// An empty map has to leave the context untouched rather than add an empty
  /// `HttpLinkHeaders` entry.
  Context _contextFor(Map<String, String> headers) {
    if (headers.isEmpty) return const Context();

    return const Context().withEntry(HttpLinkHeaders(headers: headers));
  }

  Future<Map<String, dynamic>> mutate(
    String document, {
    Map<String, dynamic> variables = const {},
  }) async {
    final QueryResult result = await _client.mutate(
      MutationOptions(
        document: gql(document),
        variables: variables,
        fetchPolicy: FetchPolicy.noCache,
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
