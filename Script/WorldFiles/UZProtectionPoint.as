import GameFiles.UZGameMode;

class AUZProtectionPoint : AActor
{
    UPROPERTY(DefaultComponent, RootComponent)
    USphereComponent SphereComp;
    default SphereComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Block); 

    UPROPERTY(DefaultComponent, Attach = SphereComp)
    UStaticMeshComponent MeshComp;

}