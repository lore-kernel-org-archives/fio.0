Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CY1PR0401MB1116F8AD0CBB303383918EA481C10@CY1PR0401MB1116.namprd04.prod.outlook.com>
References: <CY1PR0401MB11163E6C999998E0A2F13F9E81F70@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CY1PR0401MB111689EE46B3839EB0675D7B81F70@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CY1PR0401MB1116307F93264CDB7F09870981F70@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxhHoS62hDsz9cvwjYBJFODDZ6EvTry9u4nErXAC67JwKg@mail.gmail.com>
 <CY1PR0401MB111673C9DC353353BACFCE5B81F50@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CY1PR0401MB1116FC09283C22316161F3E381CE0@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxgi-muVZ4XVF53amSHOzLjMEDSY2Z2GRmKso_VZ1sVazA@mail.gmail.com>
 <CY1PR0401MB11163A5F0CE792CC28A7252D81CE0@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxiso_3xAjP1CJ91=qXcsyKcwzN2XfBeGLvPzeMj45BLGQ@mail.gmail.com>
 <CY1PR0401MB111641A66DF1AC0E016E97E181CE0@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxjmz4t_rbXuDwqPmiAPXUg_h88qvcRUGbXPCRAnDcw8Qg@mail.gmail.com> <CY1PR0401MB1116F8AD0CBB303383918EA481C10@CY1PR0401MB1116.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 1 Mar 2018 14:39:34 +0000
Message-ID: <CALjAwxg0pNhmSnvRGDL7um-KhX8eqwHfk1T8CSaQYih2c8p33Q@mail.gmail.com>
Subject: Re: fiologparser_hist.py script patch and enhancements?
Content-Type: text/plain; charset="UTF-8"
To: Kris Davis <Kris.Davis@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Hi I've been going over this:

On 26 February 2018 at 21:56, Kris Davis <Kris.Davis@wdc.com> wrote:
> Here is an updated patch against 'master' without a change to the shabang:
>
>
> diff --git a/tools/hist/fiologparser_hist.py b/tools/hist/fiologparser_hist.py
> index 62a4eb4..f71e6d0
> --- a/tools/hist/fiologparser_hist.py
> +++ b/tools/hist/fiologparser_hist.py
> @@ -16,7 +16,10 @@
>  import os
>  import sys
>  import pandas
> +import re
>  import numpy as np
> +
> +runascmd = False
>
>  err = sys.stderr.write
>
> @@ -64,8 +67,20 @@
>  def weighted_average(vs, ws):
>      return np.sum(vs * ws) / np.sum(ws)
>
> -columns = ["end-time", "samples", "min", "avg", "median", "90%", "95%", "99%", "max"]
> -percs   = [50, 90, 95, 99]
> +
> +percs = None
> +columns = None
> +
> +def gen_output_columns(percentiles):
> +    global percs,columns
> +    strpercs = re.split('[,:]', percentiles)
> +    percs = [50.0]  # always print 50% in 'median' column
> +    percs.extend(list(map(float,strpercs)))
> +    columns = ["end-time", "samples", "min", "avg", "median"]
> +    columns.extend(list(map(lambda x: x+'%', strpercs)))
> +    columns.append("max")
> +

Allegedly there's trailing whitespace here but it's hard to tell if
that's just how the patch was transferred...

> +
>
>  def fmt_float_list(ctx, num=1):
>    """ Return a comma separated list of float formatters to the required number
> @@ -178,7 +193,11 @@
>      avg = weighted_average(vs, ws)
>      values = [mn, avg] + list(ps) + [mx]
>      row = [end, ss_cnt] + [float(x) / ctx.divisor for x in values]
> -    fmt = "%d, %d, %d, " + fmt_float_list(ctx, 5) + ", %d"
> +    if ctx.divisor > 1:
> +        fmt = "%d, %d, " + fmt_float_list(ctx, len(percs)+3)

Does the + need space around it?

> +    else:
> +        # max and min are decimal values if no divisor
> +        fmt = "%d, %d, %d, " + fmt_float_list(ctx, len(percs)+1) + ", %d"

Same here - space around the "+" of +1?

<snip>

> diff --git a/tools/hist/fiologparser_hist_nw.py b/tools/hist/fiologparser_hist_nw.py
> new file mode 100755
> index 0000000..3e1be32
> --- /dev/null
> +++ b/tools/hist/fiologparser_hist_nw.py

It just seems a shame there's no way to just optionally skip the
weighting step in fiologparser_hist.py... So much of the code is the
same between these two files it's going to be a maintenance burden
keeping them in sync going forwards. I see two approaches:

1. Refactor the common code into a library and write two different
frontends that use the common library code.
2. Keep one script but somehow let it contain non-weighted vs weighted paths.

Thoughts?

At a minimum it would be good to land the changes to
fiologparser_hist.py as they seem good and not controversial...

-- 
Sitsofe | http://sucs.org/~sits/

