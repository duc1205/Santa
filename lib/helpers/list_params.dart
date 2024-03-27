import 'package:santapocket/helpers/pagination_params.dart';
import 'package:santapocket/helpers/sort_params.dart';

class ListParams {
  final PaginationParams? paginationParams;
  final SortParams? sortParams;

  ListParams({
    this.paginationParams,
    this.sortParams,
  });
}
