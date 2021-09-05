#include <iostream>
#include <stdio.h>
#include <math.h>
using namespace std;

struct Set{
    unsigned int tag; // tag
    unsigned int stamp; // time stamp
    bool v;
};

struct cache_content{
    Set* set; // tag + time stamp + valid bit
//	unsigned int	data[16];
};

const int K=1024;

double log2( double n )
{
    // log(n)/log(2) is log2.
    return log( n ) / log(double(2)) ;
}

void simulate(int cache_size, int block_size,int N,char* filename){
    
	double miss_count=0;
	double hit_count=0;
	int time=0;
	bool Hit;
	unsigned int tag,index,x;

	int offset_bit = (int) log2(block_size);
	int index_bit = (int) log2(cache_size/(block_size*N));
	int line= (cache_size>>offset_bit)/N;

	cache_content *cache =new cache_content[line];
	for(int j=0;j<line;j++)
		cache[j].set = new Set[N];
//	cout<<"[cache line]:"<<line;
/*	
	int total_bit=1<<index_bit;
	int v_bit = 1;
	int tag_bit = 32 - index_bit - offset_bit;
	total_bit *=( v_bit + tag_bit + block_size*8 )*N; // block_size = 64 byte = 64*8 bit
	cout<<"[total bit]: "<<total_bit<<"\t";
*/
	for(int j=0;j<line;j++){
        for(int k=0;k<N;k++){
            cache[j].set[k].stamp=0;
            cache[j].set[k].v=false;
        }
	}

	FILE * fp=fopen(filename,"r");
	if(!fp) exit(1);

	while(fscanf(fp,"%x",&x)!=EOF){
	    
        time++;
        Hit=false;
		//cout<<hex<<x<<" ";
		index=(x>>offset_bit)&(line-1);
		tag=x>>(index_bit+offset_bit);

        for(int i=0;i<N;i++){
			// hit
            if(cache[index].set[i].tag==tag && cache[index].set[i].v){ 
                cache[index].set[i].stamp=time; // update stamp
                hit_count++;
                Hit=true;
                break;
            }
        }
		// miss
		if(!Hit){
			int min=time;
			int victim=0;
			// choose smallest stamp (the earliest) be victim
			for(int i=0;i<N;i++){
				if(cache[index].set[i].stamp<min){
					min=cache[index].set[i].stamp;
		            victim=i;
				}
			}
			cache[index].set[victim].stamp=time;
			cache[index].set[victim].v=true;
			cache[index].set[victim].tag=tag;
			miss_count++;
		}
	}
	fclose(fp);

	int total=miss_count+hit_count;
	cout << miss_count/total*100 << "% ";

	delete [] cache;
}

int main(int argc,char* argv[]){
	int cache_size[6] = {1,2,4,8,16,32};
	int N_way[4] = {1,2,4,8};
	// Let us simulate 4KB cache with 16B blocks
	cout<<argv[1]<<endl;
	cout<<"\t1-way\t 2-way\t  4-way\t   8-way\n";
	for(int i=0;i<6;i++){
		cout<<cache_size[i]<<" k\t";
		for(int j=0;j<4;j++)
			simulate(cache_size[i]*K, 64,N_way[j],argv[1]);
		cout<<endl;
	}
}








