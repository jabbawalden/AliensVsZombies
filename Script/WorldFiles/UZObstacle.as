import WorldFiles.UZProtectionPoint;
import GameFiles.UZStaticData;
class AUZObstacle : AActor
{
    //spawn 4 actors at 4 USceneComponent locations

    UPROPERTY(DefaultComponent, RootComponent)
    USceneComponent SceneComp;

    UPROPERTY(DefaultComponent, Attach = SceneComp)
    UBoxComponent BoxComp;
    default BoxComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Block);

    UPROPERTY(DefaultComponent, Attach = BoxComp)
    UStaticMeshComponent MeshComp;
    default MeshComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Ignore);

    UPROPERTY(DefaultComponent, Attach = SceneComp)
    USceneComponent Corner1;

    UPROPERTY(DefaultComponent, Attach = SceneComp)
    USceneComponent Corner2;

    UPROPERTY(DefaultComponent, Attach = SceneComp)
    USceneComponent Corner3;

    UPROPERTY(DefaultComponent, Attach = SceneComp)
    USceneComponent Corner4;

    UPROPERTY()
    TArray<USceneComponent> SceneCompArray;

    int DistanceCheckCount;

    TArray<AUZProtectionPoint> ProtectionPointArray;

    AUZProtectionPoint ProtectionPointRef;

    UPROPERTY()
    TArray<FVector> PriorityLocationArray;

    //used to ensure that the correct locations are being added in the right order
    UPROPERTY()
    TArray<float> PriorityDistanceArray; 

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        AUZProtectionPoint::GetAll(ProtectionPointArray);
        ProtectionPointRef = ProtectionPointArray[0];
        BuildPriorityArray();
        Tags.Add(UZTags::Obstacle);
    }

    UFUNCTION()
    void BuildPriorityArray()
    {
        if (ProtectionPointRef == nullptr)
        return; 
        
        SceneCompArray.Add(Corner1);
        SceneCompArray.Add(Corner2);
        SceneCompArray.Add(Corner3);
        SceneCompArray.Add(Corner4);

        DistanceCheckCount = SceneCompArray.Num();

        for(int i = 0; i < DistanceCheckCount; i++)
        {
            Print("" + DistanceCheckCount, 5.f);
            float DistanceChecker = 500400.f;
            int SceneCompIndex = 0;
            
            for (int c = 0; c < SceneCompArray.Num(); c++)
            {
                if (DistanceToProtectionPoint(ProtectionPointRef, SceneCompArray[c]) < DistanceChecker)
                {
                    DistanceChecker = DistanceToProtectionPoint(ProtectionPointRef, SceneCompArray[c]);
                    SceneCompIndex = c;
                }
            }
            
            FVector NextLocation = SceneCompArray[SceneCompIndex].GetWorldLocation();
            PriorityLocationArray.Add(NextLocation);
            PriorityDistanceArray.Add(DistanceToProtectionPoint(ProtectionPointRef, SceneCompArray[SceneCompIndex]));
            SceneCompArray.RemoveAt(SceneCompIndex);         
        }
    }

    UFUNCTION()
    float DistanceToProtectionPoint(AUZProtectionPoint ProtectionPoint, USceneComponent Point)
    {
        float Distance = 0.f;

        Distance = (ProtectionPoint.ActorLocation - Point.GetWorldLocation()).Size();   

        return Distance;
    }

    //check in order which is closest and furtherest from the protection point



}