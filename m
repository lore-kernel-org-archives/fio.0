Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: Vincent Fu <vincentfu@gmail.com>
Subject: Re: [PATCH 1/6] stat: change json+ output format so that instead of
 printing the raw clat data structure, use actual durations instead of array
 indices and print only bins with nonzero counts
References: <1492369468-29448-1-git-send-email-vincentfu@gmail.com>
Message-ID: <23c62b4c-2aac-6a43-927f-69cfc036120a@gmail.com>
Date: Wed, 3 May 2017 10:47:38 -0400
MIME-Version: 1.0
In-Reply-To: <1492369468-29448-1-git-send-email-vincentfu@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Jens, can you review this patch series?

The json+ change (PATCH 1/6 and 2/6) was a request from a user and makes 
the output easier to use.

The other patches fix problems with resetting the latency counters when 
--latency-target is used (PATCH 4/6) and make sure some forgotten 
latency counters are transferred in client/server mode (PATCH 5/6). 
PATCH 6/6 is a cleanup. You can ignore PATCH 3/6.

Vincent

On 17-Apr-17 14:11, Vincent Fu wrote:
> From: Vincent Fu<Vincent.Fu@sandisk.com>
>
> ---
>   stat.c | 11 +++++------
>   1 file changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/stat.c b/stat.c
> index fde7af2..4a6e1b9 100644
> --- a/stat.c
> +++ b/stat.c
> @@ -98,7 +98,7 @@ static unsigned int plat_val_to_idx(unsigned int val)
>    * Convert the given index of the bucket array to the value
>    * represented by the bucket
>    */
> -static unsigned int plat_idx_to_val(unsigned int idx)
> +static unsigned long long plat_idx_to_val(unsigned int idx)
>   {
>   	unsigned int error_bits, k, base;
>   
> @@ -972,12 +972,11 @@ static void add_ddir_status_json(struct thread_stat *ts,
>   		clat_bins_object = json_create_object();
>   		json_object_add_value_object(tmp_object, "bins", clat_bins_object);
>   		for(i = 0; i < FIO_IO_U_PLAT_NR; i++) {
> -			snprintf(buf, sizeof(buf), "%d", i);
> -			json_object_add_value_int(clat_bins_object, (const char *)buf, ts->io_u_plat[ddir][i]);
> +			if (ts->io_u_plat[ddir][i]) {
> +				snprintf(buf, sizeof(buf), "%llu", plat_idx_to_val(i));
> +				json_object_add_value_int(clat_bins_object, (const char *)buf, ts->io_u_plat[ddir][i]);
> +			}
>   		}
> -		json_object_add_value_int(clat_bins_object, "FIO_IO_U_PLAT_BITS", FIO_IO_U_PLAT_BITS);
> -		json_object_add_value_int(clat_bins_object, "FIO_IO_U_PLAT_VAL", FIO_IO_U_PLAT_VAL);
> -		json_object_add_value_int(clat_bins_object, "FIO_IO_U_PLAT_NR", FIO_IO_U_PLAT_NR);
>   	}
>   
>   	if (!calc_lat(&ts->lat_stat[ddir], &min, &max, &mean, &dev)) {



