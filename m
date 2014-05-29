Return-Path: <axboe@kernel.dk>
Message-ID: <538794B5.1060705@kernel.dk>
Date: Thu, 29 May 2014 14:12:37 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: ETA no longer works when -o specified
References: <CAGw_T3o=eAEHYbQ68a+OodruxEuX0EDE9gihinb+zBkDWU_dcg@mail.gmail.com>
In-Reply-To: <CAGw_T3o=eAEHYbQ68a+OodruxEuX0EDE9gihinb+zBkDWU_dcg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: Rik Faith <rickard.faith@nutanix.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 05/28/2014 02:24 PM, Rik Faith wrote:
> Regarding fio version fio-2.1.9-17-gd9b1 (after April 11, 2014):
> 
> A recent change (5e1d8745471d1f315113c5c3fd8b93809d9ddff9) caused stdout
> to be closed when -o was specified, which prevents ETA output from showing
> up on stdout even when, e.g., json is being saved in the file.
> 
> This patch continues to close f_out so that there is no leak if multiple -o
> options are specified, but doesn't close stdout.  Hence, ETA works again
> when it should.
> 
> diff --git a/init.c b/init.c
> index 4c5a8dd..a546861 100644
> --- a/init.c
> +++ b/init.c
> @@ -1739,7 +1739,7 @@ int parse_cmd_line(int argc, char *argv[], int
> client_type)
>                         write_bw_log = 1;
>                         break;
>                 case 'o':
> -                       if (f_out)
> +                       if (f_out && f_out != stdout)
>                                 fclose(f_out);

Thanks Rik, applied.

-- 
Jens Axboe


