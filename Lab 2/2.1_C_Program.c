int main(){
    // Find the mimnimum value inside an array
	int a[5]= {1, 20, 3, 4, 5};
	int min_val;
	int i;

	min_val = a[0];

	for ( i = 1; i < 5; i++){
		if (a[i] < min_val){
			min_val = a[i];
		}
	}
	return min_val;
}
