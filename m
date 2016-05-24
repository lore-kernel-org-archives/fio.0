Return-Path: <mark.a.nelson@gmail.com>
Return-Path: <mark.a.nelson@gmail.com>
Subject: Re: fiologparser.py
References: <12634496.Be1YEipj88@merkaba>
 <2097283958.65342663.1464088355308.JavaMail.zimbra@redhat.com>
From: Mark Nelson <mark.a.nelson@gmail.com>
Message-ID: <196b983d-e6e1-2c2d-299e-de3b9cc742ff@gmail.com>
Date: Tue, 24 May 2016 09:04:14 -0500
MIME-Version: 1.0
In-Reply-To: <2097283958.65342663.1464088355308.JavaMail.zimbra@redhat.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
To: Ben England <bengland@redhat.com>, Martin Steigerwald <ms@teamix.de>
Cc: fio@vger.kernel.org, Mark Nelson <mnelson@redhat.com>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

I'm totally fine with removing .py from the name unless anyone else has 
objections.  I hadn't really thought about writing a man page, but that 
would be great if you want to give it a go.

Let's see if we can remove the numpy and scipy dependencies.  It looks 
like we are just using it for min/average/median/max/percentile 
calculations.  It would be nice if users didn't need anything other than 
argparse.

Mark

On 05/24/2016 06:12 AM, Ben England wrote:
> no objections here,
>
> There is some additional documentation in the parse_args() routine in the "help" keyword parameter to parser.add_argument.
>
>   parser.add_argument("FILE", help="collectl log output files to parse", nargs="+")
>
> it's really a fio-generated latency log, not a collectl log
>
> not aware of any dependencies except python-scipy.  It doesn't work with python3 yet.
>
> Additional documentation for the -A option is in:
>
> https://github.com/axboe/fio/pull/177
>
> -ben
>
> ----- Original Message -----
>> From: "Martin Steigerwald" <ms@teamix.de>
>> To: fio@vger.kernel.org
>> Cc: "Mark Nelson" <mnelson@redhat.com>, "Ben England" <bengland@redhat.com>, "Jens Axboe" <axboe@kernel.dk>
>> Sent: Tuesday, May 24, 2016 6:35:54 AM
>> Subject: fiologparser.py
>>
>> Hello Mark, Ben,
>>
>> I found fiologparser.py in fio 2.10 and for now packaged it into the /usr/
>> share/doc/fio. Yet I´d like to more promintly place it in /usr/bin or so… for
>> that I would need it to have no script name ending (as according to Debian
>> Policy). Would be fine with having it renamed to just  fiologparser? I can
>> provide a patch to Jens.
>>
>> Also it has no manpage, but a short intro in the script source itself. Do you
>> intent to provide a manpage? Otherwise I may have a go at it with help2man or
>> so once in a while. It appears to have quite some options:
>>
>> # ./fiologparser.py
>> usage: fiologparser.py [-h] [-i INTERVAL] [-d DIVISOR] [-f] [-A] [-a] [-s]
>>                        FILE [FILE ...]
>> fiologparser.py: error: too few arguments
>>
>> Care to elaborate what these are doing (besides what is mentioned in script
>> header)?
>>
>> It requires python-scipy it seems. Anything else?
>>
>> Thank you,
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

