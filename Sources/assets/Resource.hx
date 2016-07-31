package assets;
typedef Resource = {
    status: ResourceStatus,
    data: Dynamic
}
@IgnoreCover
enum ResourceStatus {
    OK;
    FAIL;
}