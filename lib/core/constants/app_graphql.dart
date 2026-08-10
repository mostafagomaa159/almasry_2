/// GraphQL documents, kept next to [ApiConstants] so every endpoint the app
/// talks to lives under `core/constants`.
class GraphQLDocuments {
  GraphQLDocuments._();

  static const String searchBrands = r'''
    query SearchBrands($page: Int, $pageSize: Int, $q: String) {
      getBrands(page: $page, pageSize: $pageSize, q: $q) {
        brands {
          id
          image
          name
        }
        page_info {
          page_size
          current_page
          total_pages
          total_count
        }
      }
    }
  ''';

  static const String submitContactForm = r'''
    mutation SubmitContactForm(
      $name: String!
      $email: String!
      $comment: String!
      $telephone: String
    ) {
      contactUs(
        input: {
          name: $name
          email: $email
          comment: $comment
          telephone: $telephone
        }
      ) {
        status
      }
    }
  ''';
}
