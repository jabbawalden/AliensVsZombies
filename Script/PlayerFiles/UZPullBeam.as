import WorldFiles.UZResource;

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
        AUZResource ResourceTarget = Cast<AUZResource>(OtherActor);

        if (ResourceTarget != nullptr)
        {
            ResourceTarget.SetTargetReference(this);
            ResourceTarget.IsCollecting = true;
            ResourceTarget.SetPhysicsSimulation(false);
        }
    }

    UFUNCTION()
    void TriggerOnEndOverlap(
        UPrimitiveComponent OverlappedComponent, AActor OtherActor,
        UPrimitiveComponent OtherComponent, int OtherBodyIndex) 
    {
        AUZResource ResourceTarget = Cast<AUZResource>(OtherActor);

        if (ResourceTarget != nullptr)
        {
            ResourceTarget.IsCollecting = false;
            ResourceTarget.SetPhysicsSimulation(true);
        }
    }
}