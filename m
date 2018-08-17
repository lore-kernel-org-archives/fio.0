Return-Path: <sandeen@redhat.com>
Subject: Re: [PATCH] http: fix compile-time warnings
References: <1534538814-8172-1-git-send-email-kusumi.tomohiro@gmail.com>
 <e17d9874-c854-69e4-fb89-f07a2d9f29bc@kernel.dk>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <e0ac9b5e-f358-07f0-f102-aa92a32e53c8@redhat.com>
Date: Fri, 17 Aug 2018 15:58:42 -0500
MIME-Version: 1.0
In-Reply-To: <e17d9874-c854-69e4-fb89-f07a2d9f29bc@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 8/17/18 3:52 PM, Jens Axboe wrote:
> On 8/17/18 2:46 PM, Tomohiro Kusumi wrote:
>> Fix following warnings on RHEL6 and variants.
>>
>> engines/http.c: In function 'fio_http_setup':
>> engines/http.c:611: warning: call to '_curl_easy_setopt_err_seek_cb' declared with attribute warning: curl_easy_setopt expects a curl_seek_callback argument for this option
>> engines/http.c: In function 'fio_http_queue':
>> engines/http.c:549: warning: call to '_curl_easy_setopt_err_curl_off_t' declared with attribute warning: curl_easy_setopt expects a curl_off_t argument for this option
>>
>> Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
>> ---
>>  engines/http.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/engines/http.c b/engines/http.c
>> index cb66ebe..ac4898a 100644
>> --- a/engines/http.c
>> +++ b/engines/http.c
>> @@ -546,7 +546,7 @@ static enum fio_q_status fio_http_queue(struct thread_data *td,
>>  	} else if (io_u->ddir == DDIR_TRIM) {
>>  		curl_easy_setopt(http->curl, CURLOPT_HTTPGET, 1L);
>>  		curl_easy_setopt(http->curl, CURLOPT_CUSTOMREQUEST, "DELETE");
>> -		curl_easy_setopt(http->curl, CURLOPT_INFILESIZE_LARGE, 0);
>> +		curl_easy_setopt(http->curl, CURLOPT_INFILESIZE_LARGE, (curl_off_t)0);
>>  		curl_easy_setopt(http->curl, CURLOPT_READDATA, NULL);
>>  		curl_easy_setopt(http->curl, CURLOPT_WRITEDATA, NULL);
>>  		res = curl_easy_perform(http->curl);
> 
> This looks fine.
> 
>> @@ -608,7 +608,7 @@ static int fio_http_setup(struct thread_data *td)
>>  	}
>>  	curl_easy_setopt(http->curl, CURLOPT_READFUNCTION, _http_read);
>>  	curl_easy_setopt(http->curl, CURLOPT_WRITEFUNCTION, _http_write);
>> -	curl_easy_setopt(http->curl, CURLOPT_SEEKFUNCTION, _http_seek);
>> +	curl_easy_setopt(http->curl, CURLOPT_SEEKFUNCTION, (curl_seek_callback)_http_seek);
>>  	if (o->user && o->pass) {
>>  		curl_easy_setopt(http->curl, CURLOPT_USERNAME, o->user);
>>  		curl_easy_setopt(http->curl, CURLOPT_PASSWORD, o->pass);
> 
> But this one makes me a little nervous. If _http_seek() matches the
> expected callback, and it certainly needs to, it should not warn. What's
> going on here?

https://github.com/curl/curl/issues/1403

?

-Eric


