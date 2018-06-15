Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] client: parse env variables before sending job-file
 contents to server
References: <1529075486-18805-1-git-send-email-kusumi.tomohiro@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <2f9dbd9e-1582-a702-8255-e4d467b6afa2@kernel.dk>
Date: Fri, 15 Jun 2018 08:55:59 -0600
MIME-Version: 1.0
In-Reply-To: <1529075486-18805-1-git-send-email-kusumi.tomohiro@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 6/15/18 9:11 AM, Tomohiro Kusumi wrote:
> Fixes "fio environment var bug".
> https://www.spinics.net/lists/fio/msg07093.html
> 
> Add read_ini_data() to parse and expand env variables within job-file
> before sending to server. By doing this, clients can control parameters
> embedded within the job-file, without server side having to set them
> separately.

Looks good to me, just one minor comment:

> +static int read_ini_data(int fd, void *data, size_t size)
> +{
> +	char *p = data;
> +	int ret = 0;
> +
> +	FILE *fp = fdopen(dup(fd), "r");
> +	if (!fp)
> +		return errno;
> +
> +	while (1) {
> +		ssize_t len;
> +		char buf[OPT_LEN_MAX+1], *sub;
> +
> +		if (!fgets(buf, sizeof(buf), fp)) {
> +			if (ferror(fp)) {
> +				if (errno == EAGAIN || errno == EINTR)
> +					continue;
> +				ret = errno;
> +				break;
> +			} else
> +				break;
> +		}

This should just be:

		if (!fgets(buf, sizeof(buf), fp)) {
			if (ferror(fp)) {
				if (errno == EAGAIN || errno == EINTR)
					continue;
				ret = errno;
			}
			break;
		}

I'll make that change while applying.

-- 
Jens Axboe


