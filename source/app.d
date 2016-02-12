import std.container: Array;
struct DVec3{
    double x,y,z;
}
void test1(const ref Array!DVec3 arr, size_t size, size_t jumpLength){
    import std.random;
    double sum = 0;
    for(size_t i = 0, i2 = 0; i < size; ++i){
        i2 += uniform(0,jumpLength);
        sum += arr[i].x + arr[i].y + arr[i].z;
    }
}
void test2(const ref Array!DVec3 arr, size_t size, size_t jumpLength){
    import std.random;
    double sum = 0;
    for(size_t i = 0, i2 = 0; i < size; ++i){
        i2 += uniform(0,jumpLength);
        sum += arr[i2].x + arr[i2].y + arr[i2].z;
    }
}
string benchCache(size_t size, size_t jumpLength, uint iterations){
    import std.datetime;
    import std.range;
    import std.conv;
    Array!DVec3 a1 = std.range.repeat(DVec3(1,2,3)).take(size * jumpLength);
    auto r = benchmark!(() => test1(a1, size, jumpLength), () => test2(a1, size, jumpLength))(iterations);
    double t1 = to!("seconds", double)((r[0]));
    double t2 = to!("seconds", double)((r[1]));
    return to!string(t1) ~ "," ~ to!string(t2);
}
void main()
{
    import std.stdio;
    import std.range;
    File file = File("cache.csv","w");
    foreach(jumpLength; iota(1,100)){
        file.writeln(benchCache(1000000, jumpLength, 10));
    }
}
