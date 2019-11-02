import Components.UZObjectRotation;
import PlayerFiles.UZProjectile;
import Components.UZShootComp;

class AUZRemoteCannon : AActor
{
    UPROPERTY(DefaultComponent, RootComponent)
    UBoxComponent BoxComp;

    UPROPERTY(DefaultComponent, Attach = BoxComp)
    UStaticMeshComponent MeshComp;
    default MeshComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Ignore);

    UPROPERTY(DefaultComponent, Attach = BoxComp)
    USphereComponent SphereComp;
    default SphereComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Overlap);
    default SphereComp.SetCollisionResponseToChannel(ECollisionChannel::ECC_Visibility, ECollisionResponse::ECR_Ignore);
    default SphereComp.SetCollisionResponseToChannel(ECollisionChannel::ECC_Camera, ECollisionResponse::ECR_Ignore);

    UPROPERTY(DefaultComponent, Attach = BoxComp)
    USceneComponent ShootOrigin1;

    UPROPERTY(DefaultComponent, Attach = BoxComp)
    USceneComponent ShootOrigin2;

    TArray<USceneComponent> ShootOriginArray;

    UPROPERTY(DefaultComponent)
    UUZObjectRotation ObjectRotationComp;

    UPROPERTY(DefaultComponent)
    UUZShootComp ShootComp;

    UPROPERTY()
    AActor TargetActor;

    UPROPERTY()
    TArray<AActor> EnemyArray;

    AUZProjectile ProjectileCast;

    UPROPERTY()
    FRotator LookAtRotation;

    UPROPERTY()
    float InterpSpeed = 2.5f;

    int ShootTargetIndex;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        ShootOriginArray.Add(ShootOrigin1);
        ShootOriginArray.Add(ShootOrigin2);
        SphereComp.OnComponentBeginOverlap.AddUFunction(this, n"TriggerOnBeginOverlap");
        SphereComp.OnComponentEndOverlap.AddUFunction(this, n"TriggerOnEndOverlap");
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        SetTarget();
        RotateTurret(DeltaSeconds);

        if (EnemyArray.Num() > 0)
        {
            ShootComp.FireProjectile(ShootOriginArray);
        }
    }

    UFUNCTION()
    void RotateTurret(float DeltaTime)
    {
        if (TargetActor != nullptr)
        {
            ObjectRotationComp.SetOwnerRotation(DeltaTime, TargetActor.ActorLocation); 
        }
        else
        {
            ObjectRotationComp.SetOwnerRotation(DeltaTime, FVector(0)); 
        }
    }

    UFUNCTION()
    void SetTarget()
    {
        float ClosestDistance = 15000.f;

        for(int i = 0; i < EnemyArray.Num(); i++)
        {
            float DistanceTo = GetDistanceTo(EnemyArray[i]);

            if(DistanceTo < ClosestDistance)
            {
                ClosestDistance = DistanceTo;
                TargetActor = EnemyArray[i];
            }
        }
    }

    UFUNCTION()
    void TriggerOnBeginOverlap(
        UPrimitiveComponent OverlappedComponent, AActor OtherActor,
        UPrimitiveComponent OtherComponent, int OtherBodyIndex, 
        bool bFromSweep, FHitResult& Hit) 
    {
        if (OtherActor.Tags.Contains(n"Enemy"))
        {
            EnemyArray.Add(OtherActor);
        }
    }

        UFUNCTION()
    void TriggerOnEndOverlap(
        UPrimitiveComponent OverlappedComponent, AActor OtherActor,
        UPrimitiveComponent OtherComponent, int OtherBodyIndex) 
    {
        if (OtherActor.Tags.Contains(n"Enemy"))
        {
            EnemyArray.Remove(OtherActor);
        }
    }
}