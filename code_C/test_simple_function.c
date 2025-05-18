int square( int a){
    return a*a;
}

int sum(int b, int c){
    return b + c;
}

int main(){
    int a = 0;
    int b = 2;
    int c = square(b) + a;
    printf(c);
}