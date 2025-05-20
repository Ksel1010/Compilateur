int main () {
    int a = 0;
    int b = 20;
    while (b)
    {
        a = a + 1;
        b = 20 - a;
    }
    printf(a);
}
