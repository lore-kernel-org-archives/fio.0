Return-Path: <bvanassche@acm.org>
Subject: Re: [PATCH] zbd: Fix test scripts
References: <20180831044820.22625-1-damien.lemoal@wdc.com>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <2bac4058-9631-d1f8-0273-c6a2111349b6@acm.org>
Date: Fri, 31 Aug 2018 07:10:37 -0700
MIME-Version: 1.0
In-Reply-To: <20180831044820.22625-1-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <damien.lemoal@wdc.com>, fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On 08/30/18 21:48, Damien Le Moal wrote:
> diff --git a/t/zbd/run-tests-against-regular-nullb b/t/zbd/run-tests-against-regular-nullb
> index 133c7c41..cc03e88f 100755
> --- a/t/zbd/run-tests-against-regular-nullb
> +++ b/t/zbd/run-tests-against-regular-nullb
> @@ -13,13 +13,14 @@ done
>  modprobe -r null_blk
>  [ -e /sys/module/null_blk ] && exit $?
>  modprobe null_blk nr_devices=0 &&
> -    cd /sys/kernel/config/nullb &&
> +    pushd /sys/kernel/config/nullb &&
>      mkdir nullb0 &&
>      cd nullb0 &&
>      echo 0 > completion_nsec &&
>      echo 4096 > blocksize &&
>      echo 1024 > size &&
>      echo 1 > memory_backed &&
> -    echo 1 > power
> +    echo 1 > power &&
> +    popd

pushd and popd are primarily intended for interactive use. Please
surround the code that needs the /sys/kernel/config/nullb directory with
parentheses: ( and ). That approach has two advantages:
- Forgetting to close a parenthese causes bash to complain about a
syntax error.
- No output appears on stdout if changing into a directory is successful.

Another alternative is to add something like the following at the start
of the script and to use ${scriptdir} instead of $(dirname "$0"):

scriptdir="$(cd "$(dirname "$0")" && pwd)"

Thanks,

Bart.

