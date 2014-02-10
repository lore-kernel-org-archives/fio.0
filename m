Return-Path: <axboe@kernel.dk>
Date: Mon, 10 Feb 2014 13:48:05 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Mutex destruction, invalid memory accesses, leaks
Message-ID: <20140210204805.GB4096@kernel.dk>
References: <20140206192135.GB3950@kernel.dk>
 <20140207034439.GA17588@sucs.org>
 <52F505A8.30004@kernel.dk>
 <20140209195042.GA17058@sucs.org>
 <52F927AC.6020007@cran.org.uk>
 <20140210202245.GA6747@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20140210202245.GA6747@sucs.org>
To: Sitsofe Wheeler <sitsofe@yahoo.com>, Bruce Cran <bruce@cran.org.uk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>



On 02/10/2014 01:22 PM, Sitsofe Wheeler wrote:
> On Mon, Feb 10, 2014 at 12:25:32PM -0700, Bruce Cran wrote:
>> On 2/9/2014 12:50 PM, Sitsofe Wheeler wrote:
>>>
>>> Yes it's still happening with -git from a moment ago. What is stopping a
>>> sleeping thread from holding a mutex that is destroyed and then waking
>>> up on it after the memory has been unmapped?
>>
>> In case it *is* a bug in winpthreads-1.dll, are you using version
>> 3.1.0-1? It was released on the 15th January and there appeared to
>> be some mutex-related fixes when I looked at the svn log a few weeks
>> ago.
>
> Yes I am using version 3.1.0-1 on Windows 7 installed about a week
> ago...

I think I see what is going on here... It's not that the mutexes are 
broken on Windows, it's just that it probably has different scheduling 
behaviour. If the pthread_cond_signal() ends up preempting to the thread 
being woken up, then the memory allocated to the mutex could be gone 
before we get a chance to inc and unlock it.

Could you test the below and see if it fixes it?

diff --git a/backend.c b/backend.c
index 501c59a..841e54b 100644
--- a/backend.c
+++ b/backend.c
@@ -1886,7 +1886,7 @@ static void run_threads(void)
 			m_rate += ddir_rw_sum(td->o.ratemin);
 			t_rate += ddir_rw_sum(td->o.rate);
 			todo--;
-			fio_mutex_up(td->mutex);
+			fio_mutex_up_for_removal(td->mutex);
 		}
 
 		reap_threads(&nr_running, &t_rate, &m_rate);
diff --git a/mutex.c b/mutex.c
index e1fbb60..5eb0af8 100644
--- a/mutex.c
+++ b/mutex.c
@@ -141,6 +141,21 @@ void fio_mutex_down(struct fio_mutex *mutex)
 	pthread_mutex_unlock(&mutex->lock);
 }
 
+/*
+ * Special case fio_mutex_up() that doesn't touch the mutex after
+ * waking up. As such it's only safe if we know the waker is immediately
+ * going to kill the mutex, as it's left in a half-undefined state.
+ */
+void fio_mutex_up_for_removal(struct fio_mutex *mutex)
+{
+	assert(mutex->magic == FIO_MUTEX_MAGIC);
+
+	pthread_mutex_lock(&mutex->lock);
+	read_barrier();
+	if (!mutex->value && mutex->waiters)
+		pthread_cond_signal(&mutex->cond);
+}
+
 void fio_mutex_up(struct fio_mutex *mutex)
 {
 	assert(mutex->magic == FIO_MUTEX_MAGIC);
diff --git a/mutex.h b/mutex.h
index 4f3486d..1b03ba1 100644
--- a/mutex.h
+++ b/mutex.h
@@ -27,6 +27,7 @@ enum {
 extern struct fio_mutex *fio_mutex_init(int);
 extern void fio_mutex_remove(struct fio_mutex *);
 extern void fio_mutex_up(struct fio_mutex *);
+extern void fio_mutex_up_for_removal(struct fio_mutex *);
 extern void fio_mutex_down(struct fio_mutex *);
 extern int fio_mutex_down_timeout(struct fio_mutex *, unsigned int);
 

-- 
Jens Axboe

