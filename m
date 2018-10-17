Return-Path: <sboisvert@gydle.com>
Subject: Re: [PATCH v2 1/4] fio: add function to check for serialize_overlap
 with offload submission
References: <20181017145225.14546-1-vincentfu@gmail.com>
 <20181017145225.14546-2-vincentfu@gmail.com>
From: =?UTF-8?Q?S=c3=a9bastien_Boisvert?= <sboisvert@gydle.com>
Message-ID: <3886cf4c-4c8c-e4da-d064-f6ef1c5d76f7@gydle.com>
Date: Wed, 17 Oct 2018 11:33:01 -0400
MIME-Version: 1.0
In-Reply-To: <20181017145225.14546-2-vincentfu@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: vincentfu@gmail.com, axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>



On 2018-10-17 10:52 AM, vincentfu@gmail.com wrote:
> From: Vincent Fu <vincent.fu@wdc.com>
> 
> In multiple places fio needs to check whether it is carrying out overlap
> checking in offload submission mode. Make this check a function to
> improve code readability.
> ---
>  backend.c   | 4 ++--
>  fio.h       | 5 +++++
>  ioengines.c | 2 +-
>  3 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/backend.c b/backend.c
> index cc3c4e78..f0a45bc8 100644
> --- a/backend.c
> +++ b/backend.c
> @@ -1874,10 +1874,10 @@ static void *thread_main(void *data)
>  			 "perhaps try --debug=io option for details?\n",
>  			 td->o.name, td->io_ops->name);
>  
> -	if (td->o.serialize_overlap && td->o.io_submit_mode == IO_MODE_OFFLOAD)
> +	if (td_offload_overlap(td))
>  		pthread_mutex_lock(&overlap_check);
>  	td_set_runstate(td, TD_FINISHING);
> -	if (td->o.serialize_overlap && td->o.io_submit_mode == IO_MODE_OFFLOAD)
> +	if (td_offload_overlap(td))
>  		pthread_mutex_unlock(&overlap_check);
>  
>  	update_rusage_stat(td);
> diff --git a/fio.h b/fio.h
> index e394e165..f46a4c9b 100644
> --- a/fio.h
> +++ b/fio.h
> @@ -772,6 +772,11 @@ static inline bool td_async_processing(struct thread_data *td)
>  	return (td->flags & TD_F_NEED_LOCK) != 0;
>  }
>  
> +static inline bool td_offload_overlap(struct thread_data *td)
> +{
> +	return (td->o.serialize_overlap && td->o.io_submit_mode == IO_MODE_OFFLOAD);

The parentheses can be removed:

return td->o.serialize_overlap && td->o.io_submit_mode == IO_MODE_OFFLOAD;

> +}
> +
>  /*
>   * We currently only need to do locking if we have verifier threads
>   * accessing our internal structures too
> diff --git a/ioengines.c b/ioengines.c
> index 47f606a7..56723add 100644
> --- a/ioengines.c
> +++ b/ioengines.c
> @@ -288,7 +288,7 @@ enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
>  
>  	assert((io_u->flags & IO_U_F_FLIGHT) == 0);
>  	io_u_set(td, io_u, IO_U_F_FLIGHT);
> -	if (td->o.serialize_overlap && td->o.io_submit_mode == IO_MODE_OFFLOAD)
> +	if (td_offload_overlap(td))
>  		pthread_mutex_unlock(&overlap_check);
>  
>  	assert(fio_file_open(io_u->file));
> 

Reviewed-by: Sebastien Boisvert <sboisvert@gydle.com>

