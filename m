Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH v2] http: fix compile-time warnings
Date: Fri, 17 Aug 2018 15:22:00 -0700
Message-Id: <1534544520-19149-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

Fix following warnings on RHEL6 and variants.

engines/http.c: In function 'fio_http_setup':
engines/http.c:611: warning: call to '_curl_easy_setopt_err_seek_cb' declared with attribute warning: curl_easy_setopt expects a curl_seek_callback argument for this option
engines/http.c: In function 'fio_http_queue':
engines/http.c:549: warning: call to '_curl_easy_setopt_err_curl_off_t' declared with attribute warning: curl_easy_setopt expects a curl_off_t argument for this option

For engines/http.c:611, pass &_http_seek instead of cast, since
lack of cast isn't fio's issue. See below comments for details.

"Re: [PATCH] http: fix compile-time warnings"
https://www.spinics.net/lists/fio/msg07246.html
---
>>>> @@ -608,7 +608,7 @@ static int fio_http_setup(struct thread_data *td)
>>>>      }
>>>>      curl_easy_setopt(http->curl, CURLOPT_READFUNCTION, _http_read);
>>>>      curl_easy_setopt(http->curl, CURLOPT_WRITEFUNCTION, _http_write);
>>>> -    curl_easy_setopt(http->curl, CURLOPT_SEEKFUNCTION, _http_seek);
>>>> +    curl_easy_setopt(http->curl, CURLOPT_SEEKFUNCTION, (curl_seek_callback)_http_seek);
>>>>      if (o->user && o->pass) {
>>>>              curl_easy_setopt(http->curl, CURLOPT_USERNAME, o->user);
>>>>              curl_easy_setopt(http->curl, CURLOPT_PASSWORD, o->pass);
>>>
>>> But this one makes me a little nervous. If _http_seek() matches the
>>> expected callback, and it certainly needs to, it should not warn. What's
>>> going on here?
>>
>> https://github.com/curl/curl/issues/1403
>>
>> ?
>
> Looks like the same issue, so I guess we can just leave this warning ?
>
> The curl header uses __builtin_types_compatible_p() for
> CURLOPT_SEEKFUNCTION, which is the cause of this curl issue.
>
> and _http_seek() in fio does have the correct type.
>
>     472 static int _http_seek(void *stream, curl_off_t offset, int origin)
>
>     207 typedef int (*curl_seek_callback)(void *instream,
>     208                                   curl_off_t offset,
>     209                                   int origin); /* 'whence' */

Can we work around it by using &_http_seek? The end result would be the
same, but if it gets rid of the warning...
---

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 engines/http.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/engines/http.c b/engines/http.c
index cb66ebe..93fcd0d 100644
--- a/engines/http.c
+++ b/engines/http.c
@@ -546,7 +546,7 @@ static enum fio_q_status fio_http_queue(struct thread_data *td,
 	} else if (io_u->ddir == DDIR_TRIM) {
 		curl_easy_setopt(http->curl, CURLOPT_HTTPGET, 1L);
 		curl_easy_setopt(http->curl, CURLOPT_CUSTOMREQUEST, "DELETE");
-		curl_easy_setopt(http->curl, CURLOPT_INFILESIZE_LARGE, 0);
+		curl_easy_setopt(http->curl, CURLOPT_INFILESIZE_LARGE, (curl_off_t)0);
 		curl_easy_setopt(http->curl, CURLOPT_READDATA, NULL);
 		curl_easy_setopt(http->curl, CURLOPT_WRITEDATA, NULL);
 		res = curl_easy_perform(http->curl);
@@ -608,7 +608,7 @@ static int fio_http_setup(struct thread_data *td)
 	}
 	curl_easy_setopt(http->curl, CURLOPT_READFUNCTION, _http_read);
 	curl_easy_setopt(http->curl, CURLOPT_WRITEFUNCTION, _http_write);
-	curl_easy_setopt(http->curl, CURLOPT_SEEKFUNCTION, _http_seek);
+	curl_easy_setopt(http->curl, CURLOPT_SEEKFUNCTION, &_http_seek);
 	if (o->user && o->pass) {
 		curl_easy_setopt(http->curl, CURLOPT_USERNAME, o->user);
 		curl_easy_setopt(http->curl, CURLOPT_PASSWORD, o->pass);
-- 
1.7.1


