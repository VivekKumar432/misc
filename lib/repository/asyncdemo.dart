void main() {
  print("Go to the Mall"); // Sync (Blocking)
  Function callMeBack = (String status) {
    print("Get the Pizza " + status);
  };
  orderPizza(callMeBack); // Async
  print("Other Shopping"); // Sync
}

orderPizza(Function callMeBack) {
  Future.delayed(const Duration(seconds: 5), () {
    print("Pizza Done...");
    callMeBack("Ur Pizza is Ready");
  });
}
