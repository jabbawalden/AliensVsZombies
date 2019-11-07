import GameFiles.UZStaticData;

class AUZLocActor : AActor
{
    UPROPERTY(DefaultComponent, RootComponent)
    USphereComponent SphereComp;
    default SphereComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Ignore);
    default SphereComp.SetCollisionResponseToChannel(ECollisionChannel::ECC_Visibility, ECollisionResponse::ECR_Overlap);

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        Tags.Add(UZTags::PriorityTarget);
    }
}