Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v2] http: fix compile-time warnings
References: <1534544520-19149-1-git-send-email-kusumi.tomohiro@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <b6e05ca3-5ce7-01f9-d988-ab42b8f3d85b@kernel.dk>
Date: Fri, 17 Aug 2018 17:28:38 -0600
MIME-Version: 1.0
In-Reply-To: <1534544520-19149-1-git-send-email-kusumi.tomohiro@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 8/17/18 4:22 PM, Tomohiro Kusumi wrote:
> Fix following warnings on RHEL6 and variants.
> 
> engines/http.c: In function 'fio_http_setup':
> engines/http.c:611: warning: call to '_curl_easy_setopt_err_seek_cb' declared with attribute warning: curl_easy_setopt expects a curl_seek_callback argument for this option
> engines/http.c: In function 'fio_http_queue':
> engines/http.c:549: warning: call to '_curl_easy_setopt_err_curl_off_t' declared with attribute warning: curl_easy_setopt expects a curl_off_t argument for this option

Applied, thanks.

-- 
Jens Axboe


