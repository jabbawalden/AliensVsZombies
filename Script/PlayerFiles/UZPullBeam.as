import WorldFiles.UZPickUpObject;
import Components.UZHealthComp;

class AUZPullBeam : AActor
{
    UPROPERTY(DefaultComponent, RootComponent)
    USceneComponent SceneComp;

    UPROPERTY(DefaultComponent, Attach = SceneComp)
    UBoxComponent BoxComp;
    default BoxComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Overlap);

    UPROPERTY(DefaultComponent, Attach = SceneComp)
    UStaticMeshComponent MeshComp;
    default MeshComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Ignore);

    UPROPERTY()
    float HealAmount = 10.f;
    UPROPERTY()
    float HealRate = 0.25f;
    float NewHealTime;

    TArray<UUZHealthComp> HealthCompArray;

    AActor PlayerRef;

    bool IsActive = true;



    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        BoxComp.OnComponentBeginOverlap.AddUFunction(this, n"TriggerOnBeginOverlap");
        BoxComp.OnComponentEndOverlap.AddUFunction(this, n"TriggerOnEndOverlap");
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        if (!IsActive)
        {
            DestroyActor();
        }
    }

    UFUNCTION()
    void SetFollowTarget(AActor TargetActor)
    {
        AttachToActor(TargetActor);
    }

    UFUNCTION()
    void TriggerOnBeginOverlap(
        UPrimitiveComponent OverlappedComponent, AActor OtherActor,
        UPrimitiveComponent OtherComponent, int OtherBodyIndex, 
        bool bFromSweep, FHitResult& Hit) 
    {
        if (OtherActor.Tags.Contains(n"PickUp"))
        {
            AUZPickUpObject PickUpTarget = Cast<AUZPickUpObject>(OtherActor);

            if (PickUpTarget != nullptr)
            {
                PickUpTarget.SetTargetReference(this);
                PickUpTarget.IsCollecting = true;
                PickUpTarget.SetPhysicsSimulation(false);
            }
        }

        if (OtherActor.Tags.Contains(n"Turet"))
        {
            
        }
    }

    UFUNCTION()
    void TriggerOnEndOverlap(
        UPrimitiveComponent OverlappedComponent, AActor OtherActor,
        UPrimitiveComponent OtherComponent, int OtherBodyIndex) 
    {
        if (OtherActor.Tags.Contains(n"PickUp"))
        {
            AUZPickUpObject PickUpTarget = Cast<AUZPickUpObject>(OtherActor);

            if (PickUpTarget != nullptr)
            {
                PickUpTarget.IsCollecting = false;
                PickUpTarget.SetPhysicsSimulation(true);
            }
        }

        if (OtherActor.Tags.Contains(n"Turet"))
        {
            
        }
    }
}