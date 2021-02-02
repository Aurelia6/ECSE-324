extern int MIN_2(int x, int y);

int main(){
    // Find the minimum value inside an array,
    // By using an Assembly program
    int a[5] = {1, 20, 3, 4, 5};
    int min_val;
    int i;
    min_val = a[0];
    
    for (i = 1; i < 5; i++){
        min_val = MIN_2(min_val, a[i]);
    }
	return min_val;
}

