const baseUrl = "http://www.wanandroid.com";
const bannerUrl = baseUrl + '/banner/json';

indexArticle(int index) {
  return baseUrl + '/article/list/${index}/json';
}
