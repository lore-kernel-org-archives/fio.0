Return-Path: <axboe@kernel.dk>
Message-ID: <548F495F.7090200@kernel.dk>
Date: Mon, 15 Dec 2014 13:49:35 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio main thread got stuck over the weekend
References: <20140811154423.GE7486@beardog.cce.hp.com> <20140811160418.GG7486@beardog.cce.hp.com> <53F79442.6010500@kernel.dk> <20140822190924.GQ19666@beardog.cce.hp.com> <53F795E0.3090806@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B40295940B8A0@G4W3202.americas.hpqcorp.net> <548BC55F.9020706@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B40295940EEC5@G4W3202.americas.hpqcorp.net> <548F1C65.2070501@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B40295940F1BF@G4W3202.americas.hpqcorp.net> <548F40A8.3010405@kernel.dk> <548F452D.7040401@kernel.dk>
In-Reply-To: <548F452D.7040401@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------010402000108060605030207"
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "stephenmcameron@gmail.com" <stephenmcameron@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------010402000108060605030207
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 12/15/2014 01:31 PM, Jens Axboe wrote:
> On 12/15/2014 01:12 PM, Jens Axboe wrote:
>>> (gdb) thread 212
>>> [Switching to thread 212 (Thread 0x7fa9a086e700 (LWP 6509))]#0  0x0000003974c0b98e in pthread_cond_timedwait@@GLIBC_2.3.2 () from /lib64/libpthread.so.0
>>> (gdb) bt
>>> #0  0x0000003974c0b98e in pthread_cond_timedwait@@GLIBC_2.3.2 () from /lib64/libpthread.so.0
>>> #1  0x0000000000449381 in helper_thread_main (data=<value optimized out>) at backend.c:2127
>>> #2  0x0000003974c079d1 in start_thread () from /lib64/libpthread.so.0
>>> #3  0x00000039748e8b7d in clone () from /lib64/libc.so.6
>>> (gdb) select-frame 1
>>> (gdb) info local
>>> ts = {tv_sec = 1418658662, tv_nsec = 980074000}
>>> tv = {tv_sec = 1418658662, tv_usec = 730074}
>>> ret = <value optimized out>
>>> (gdb) print helper_exit
>>> $36 = 0
>>> (gdb) print nr_thread
>>> $37 = 224
>>> (gdb) print nr_process
>>> $38 = 0
>>
>> This is the helper thread, this is what will output the ETA etc stats.
>> There's a signal handler that runs and sets/wakes it to do so. So it
>> would be interesting if you could see what it is up to, set a break
>> point in there and check what the control flow ends up being.
>>
>> It's backend.c:helper_thread_main()
>>
>> backend.c:sig_show_status() should repeatedly fire and end up waking
>> this thread.
> 
> So that referred to the output status, your bug was on the ETA, correct?
> For that, we never get woken up by someone signaling our condvar, we
> just wake up every second to do the ETA display. The time conversion
> looks wrong, though:
> 
> gettimeofday(&tv, NULL);
> ts.tv_sec = tv.tv_sec + sec;
> ts.tv_nsec = (tv.tv_usec * 1000) + nsec;
> if (ts.tv_nsec > 1000000000ULL) {
> 	ts.tv_nsec -= 1000000000ULL;
> 	ts.tv_sec++;
> }
> 
> I wonder what happens if ts.tv_nsec == 10^6, that check really should be
> on >= instead. Not sure if this explains it though, I'll conjure up a
> test case...

On my system, pthread_cond_timedwait() returns EINVAL if nsec is 10^9 or
higher, which is the sane thing to do. I wonder if it does that at your
end too, or whether it hangs? If it hangs indefinitely, that could
explain it. Test case attached, I checked in a fix for the off-by-one.

-- 
Jens Axboe


--------------010402000108060605030207
Content-Type: text/x-csrc;
 name="cvtest.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cvtest.c"

/*
 * gcc -Wall -O2 -o cvtest cvtest.c -lpthread
 */
#include <stdio.h>
#include <limits.h>
#include <inttypes.h>
#include <stdlib.h>
#include <assert.h>
#include <sys/time.h>
#include <string.h>
#include <pthread.h>

#define DISK_UTIL_MSEC	250

struct d {
	pthread_mutex_t *lock;
	pthread_cond_t *cond;
};

static void *thread(void *data)
{
	struct d *d = data;
	struct timespec ts;
	struct timeval tv;
	int ret;

	gettimeofday(&tv, NULL);
	ts.tv_sec = tv.tv_sec + 1;
	ts.tv_nsec = 1000000000ULL;

	printf("will wait\n");
	pthread_mutex_lock(d->lock);
	ret = pthread_cond_timedwait(d->cond, d->lock, &ts);
	pthread_mutex_unlock(d->lock);
	printf("done wait %d\n", ret);
	return NULL;
}

int main(int argc, char *argv[])
{
	pthread_cond_t cond;
	pthread_mutex_t lock;
	pthread_t pthread;
	struct d d;
	void *ret;

	pthread_cond_init(&cond, NULL);
	pthread_mutex_init(&lock, NULL);

	d.lock = &lock;
	d.cond = &cond;

	pthread_create(&pthread, NULL, thread, &d);
	pthread_join(pthread, &ret);

	return 0;
}

--------------010402000108060605030207--

