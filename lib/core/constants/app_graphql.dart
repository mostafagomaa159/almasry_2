/// GraphQL documents, kept next to [ApiConstants] so every endpoint the app
/// talks to lives under `core/constants`.
class GraphQLDocuments {
  GraphQLDocuments._();

  /// Everything the product details screen renders, in one round trip —
  /// gallery, prices, specifications, reviews and the related carousels.
  static const String getProductDetail = r'''
    query GetProductDetail($sku: String!) {
      products(filter: { sku: { eq: $sku } }) {
        items {
          __typename
          id
          uid
          sku
          name
          description {
            html
          }
          short_description {
            html
          }
          brand_detail {
            name
            url_alias
            image
            small_image
          }
          custom_attributes {
            selected_attribute_options {
              attribute_option {
                uid
                label
                is_default
              }
            }
            entered_attribute_value {
              value
            }
            attribute_metadata {
              uid
              code
              label
              data_type
              is_system
              ui_input {
                ui_input_type
                is_html_allowed
              }
            }
          }
          product_labels {
            product_details_label_text
            product_details_label_image
            product_details_label_class
            product_details_label_position
            product_details_label_css_style
          }
          price_range {
            minimum_price {
              regular_price {
                value
                currency
              }
              final_price {
                value
                currency
              }
              discount {
                percent_off
                amount_off
              }
            }
            maximum_price {
              regular_price {
                value
                currency
              }
              final_price {
                value
                currency
              }
            }
          }
          price_tiers {
            quantity
            final_price {
              value
              currency
            }
            discount {
              percent_off
            }
          }
          special_price
          special_to_date
          image {
            url
            label
          }
          small_image {
            url
            label
          }
          thumbnail {
            url
            label
          }
          media_gallery {
            __typename
            url
            label
            position
            disabled
            ... on ProductVideo {
              video_content {
                media_type
                video_provider
                video_url
                video_title
                video_description
              }
            }
          }
          stock_status
          only_x_left_in_stock
          categories {
            uid
            name
            url_key
            url_path
          }
          rating_summary
          review_count
          reviews(pageSize: 5) {
            items {
              summary
              text
              nickname
              created_at
              average_rating
              ratings_breakdown {
                name
                value
              }
            }
            page_info {
              current_page
              page_size
              total_pages
            }
          }
          related_products {
            uid
            sku
            name
            thumbnail {
              url
            }
            price_range {
              minimum_price {
                final_price {
                  value
                  currency
                }
              }
            }
          }
          upsell_products {
            uid
            sku
            name
            thumbnail {
              url
            }
            price_range {
              minimum_price {
                final_price {
                  value
                  currency
                }
              }
            }
          }
          crosssell_products {
            uid
            sku
            name
            thumbnail {
              url
            }
            price_range {
              minimum_price {
                final_price {
                  value
                  currency
                }
              }
            }
          }
          country_of_manufacture
          ... on SimpleProduct {
            weight
          }
        }
      }
    }
  ''';

  /// Backs "More From This Brand". `related_products` is a curated list the
  /// catalogue leaves empty, so the carousel filters the catalogue on the
  /// brand attribute instead.
  static const String productsByBrand = r'''
    query ProductsByBrand($brandId: String!, $pageSize: Int!) {
      products(filter: { brand: { eq: $brandId } }, pageSize: $pageSize) {
        total_count
        items {
          uid
          sku
          name
          thumbnail {
            url
          }
          price_range {
            minimum_price {
              final_price {
                value
                currency
              }
            }
          }
        }
      }
    }
  ''';

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

  /// One document serves both search modes — Magento's `search` argument
  /// matches the SKU as well as the name, so the screen never has to ask the
  /// user which one they typed.
  static const String searchProducts = r'''
    query SearchProducts(
      $searchText: String!
      $pageSize: Int!
      $currentPage: Int!
      $filters: ProductAttributeFilterInput
    ) {
      products(
        search: $searchText
        pageSize: $pageSize
        currentPage: $currentPage
        filter: $filters
      ) {
        total_count
        items {
          id
          type_id
          name
          sku
          stock_status
          sellable_quantity
          webrotate_path
          webrotate_json
          image {
            url
          }
          price_range {
            minimum_price {
              regular_price {
                value
              }
              final_price {
                value
              }
            }
          }
          product_labels {
            product_details_label_text
            product_details_label_image
            product_details_label_class
            product_details_label_position
            product_details_label_css_style
          }
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
