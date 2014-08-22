Return-Path: <axboe@kernel.dk>
Message-ID: <53F7C0FE.40100@kernel.dk>
Date: Fri, 22 Aug 2014 17:15:26 -0500
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Client/Server and output
References: <CALKLVuJSzuooL3PqXY2_LHwQLKBbwzkieTAvbtiFEjVgXzSqfQ@mail.gmail.com>
In-Reply-To: <CALKLVuJSzuooL3PqXY2_LHwQLKBbwzkieTAvbtiFEjVgXzSqfQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Castor Fu <castor@egocast.org>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2014-08-21 09:28, Castor Fu wrote:
> I've been having problems with the client/server mode of fio where
> occasionally I will get CRC errors or packet mismatches.
>
> I think the source of the problem is that the file descriptor for the
> socket is 1 or 2 and something is writing to stdout or stderr.  After
> I cleaned up some problems with my plugin the problem seems to have
> gone away.
>
> It looks like there are a few places where this can happen:
>
> In fio.h fio_assert writes to stderr ... Maybe this should use f_err?
>
> The debug malloc also writes to stderr if it detects memory corruption...
>
> Also in  json_object_add_client_info, if no hostname is specified,
> client->hostname is NULL so we'll dump core...
>
> iff --git a/client.c b/client.c
> index 1f52734..78a957e 100644
> --- a/client.c
> +++ b/client.c
> @@ -825,7 +825,8 @@ static void convert_gs(struct group_run_stats
> *dst, struct group_run_stats *src)
>   static void json_object_add_client_info(struct json_object *obj,
>   struct fio_client *client)
>   {
> -       json_object_add_value_string(obj, "hostname", client->hostname);
> +       const char *hostname = client->hostname ? client->hostname : "";
> +       json_object_add_value_string(obj, "hostname", hostname);
>          json_object_add_value_int(obj, "port", client->port);
>   }

Thanks for the patch, will apply it.

On the fd being 1 or 2, that's a really good point. It might be a good 
idea to just ensure that we keep them open, instead of closing them and 
wreaking havoc if some odd code path ends up writing to stdout or 
stderr. That would seem a much safer option... Basically just remove the 
closing of STDOUT/STDERR in fio_start_server().

-- 
Jens Axboe


