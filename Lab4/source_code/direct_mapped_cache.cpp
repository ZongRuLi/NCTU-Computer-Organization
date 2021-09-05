#include <iostream>
#include <stdio.h>
#include <math.h>

using namespace std;

struct cache_content
{
	bool v;
	unsigned int tag;
    // unsigned int	data[16];
};

const int K = 1024;

double log2( double n)
{  
    // log(n) / log(2) is log2.
    return log(n) / log(double(2));
}

void simulate(int cache_size, int block_size,char* filename)
{
	unsigned int tag, index, x;
	double hit_count =0;
	double miss_count =0;

	int offset_bit = (int)log2(block_size);
	int index_bit = (int)log2(cache_size / block_size);
	int line = cache_size >> (offset_bit);

	cache_content *cache = new cache_content[line];
	
    //cout << "[block size]: "<<block_size<<"\t";
	//cout << [cache line]: " << line << "  \t";

	for(int j = 0; j < line; j++)
		cache[j].v = false;
	
    FILE *fp = fopen(filename, "r");  // read file
	
	while(fscanf(fp, "%x", &x) != EOF)
    {
		//cout << hex << x << " ";
		index = (x >> offset_bit) & (line - 1);
		tag = x >> (index_bit + offset_bit);
		if(cache[index].v && cache[index].tag == tag)
		{
			cache[index].v = true;    // hit
			hit_count++;
		}
		else
        {
			cache[index].v = true;  // miss
			cache[index].tag = tag;
			miss_count++;
		}
	}
	fclose(fp);
	int total = miss_count+hit_count;
	cout<<miss_count/total*100<<"% ";

	delete [] cache;
}
	
int main(int argc,char* argv[])
{
	int cache_size[4] = {4,16,64,256};
	int block_size[5] = {16,32,64,128,256};

	// Let us simulate 4KB cache with 16B blocks
	cout<<argv[1]<<endl;
	for(int i=0;i<4;i++){
		cout<<cache_size[i]<<" k\t";
		for(int j=0;j<5;j++)
			simulate(cache_size[i] * K, block_size[j], argv[1]);
		cout<<endl;
	}
	cout<<"\t16\t 32\t  64\t    128\t     256"<<endl;
}
