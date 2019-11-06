class UUZEndgameWidget : UUserWidget
{
    //info for points picked up?
}

UFUNCTION(Category = "Player HUD")
void AddEndGameWidgetToHUD(APlayerController PlayerController, TSubclassOf<UUserWidget> WidgetClass)
{
    UUserWidget UserWidget = WidgetBlueprint::CreateWidget(WidgetClass, PlayerController);
    UserWidget.AddToViewport();
}