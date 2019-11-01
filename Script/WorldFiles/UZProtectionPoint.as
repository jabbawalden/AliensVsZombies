import GameFiles.UZGameMode;

class AUZProtectionPoint : AActor
{
    UPROPERTY(DefaultComponent, RootComponent)
    USphereComponent SphereComp;
    default SphereComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Block); 

    UPROPERTY(DefaultComponent, Attach = SphereComp)
    UStaticMeshComponent MeshComp;

    //get game mode
    AUZGameMode GameMode;

    //When enemy enters, deduct points and check if above 0
    //if not, call GameMode functions for end game
}