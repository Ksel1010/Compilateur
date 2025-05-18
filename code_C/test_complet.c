int print_n(int to_print, int n){
    int i ;
    for (i = 0; i < n ; i = i + 1){
        print(to_print);
    }
}

int main(){
    int a = 0;
    int b = 5;
    a = a + b;
    if (a==0){
        if (b==0){
            print_n(b, b);
        }else{
            print_n(a, a);
        }
    }
}