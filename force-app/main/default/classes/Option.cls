public with sharing class Option implements Comparable {
  @AuraEnabled
  public String label { get; set; }
  @AuraEnabled
  public string value { get; set; }
  public Option(string value, string label) {
    this.value = value;
    this.label = label;
  }

  // This method is the implementation of Comparable, and is used to sort Options
  public Integer compareTo(Object compareTo) {
    Option compare = (Option) compareTo;
    if (compare.label > label)
      return -1;
    if (compare.label == label)
      return 0;
    return 1;
  }
}
