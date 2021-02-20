public with sharing class ProductController {
    static Integer PAGE_SIZE = 8;

    public class Filters {
        @AuraEnabled
        public String searchKey { get; set; }
    }
    
    @AuraEnabled(Cacheable=true)
    public static PagedResult getProducts(Filters filters, Integer pageNumber) {
        String key = '';
        String whereClause = '';
        String criteria;
        if (filters != null) {
            if (!String.isEmpty(filters.searchKey)) {
                key = '%' + filters.searchKey + '%';
                criteria = 'Name LIKE :key';
                whereClause = 'WHERE ' + criteria;
            }
        }
        Integer pageSize = ProductController.PAGE_SIZE;
        Integer offset = (pageNumber - 1) * pageSize;
        PagedResult result = new PagedResult();
        result.pageSize = pageSize;
        result.pageNumber = pageNumber;
        result.totalItemCount = Database.countQuery(
             'SELECT count() FROM Product2 ' + whereClause
         );
        result.records = Database.query(
            'Select id, ProductCode,Family, Name, MSRP__c, ' + 
            'Picture_URL__c, Description From Product2 ' + 
            whereClause + 
            ' WITH SECURITY_ENFORCED' +
            ' ORDER BY Name LIMIT :pageSize OFFSET :offset'
        );
        return result;
    }
}