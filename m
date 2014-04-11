Return-Path: <axboe@kernel.dk>
Message-ID: <53480E91.2000805@kernel.dk>
Date: Fri, 11 Apr 2014 09:47:29 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: No IOPS reported when "REPLAY_NO_STALL" is not set
References: <CAEyTGCeu0P3uG1X3ObBfDF7pUrwa2hqbvvLyws2W4DSNH+UeuQ@mail.gmail.com>	<53471606.3010505@kernel.dk> <CAEyTGCfybCJ-EoDMouX5puAnicpnk_MVtm+H4JLSzgNAYPQSjw@mail.gmail.com>
In-Reply-To: <CAEyTGCfybCJ-EoDMouX5puAnicpnk_MVtm+H4JLSzgNAYPQSjw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Lakshmi <sendtold@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 04/11/2014 09:36 AM, Lakshmi wrote:
> Hi Jens,
>
> Thanks for the command. I was looking for something like this.
> However, I am still confused on the time stamp calculation.
> My Binary file had the starting time as "26.040173218 seconds" , but
> with the below command,
>
> cat file_54657438_1000lines.bin | blkparse - | less
>
>    8,0   60        0     0.000000000 54657438  Q   R 24014152 + 8 [(null)]
>    8,0   60        0    66.860158593 54657438  Q   R 805379152 +8 [(null)]
>    8,0   60        0    80.644832628 54657438  Q   R 24014160 + 8 [(null)]
>
> The first line starts at 0 timestamp and then 66sec etc. I dont
> understand how the 66sec is calculated in the above blkparse command.
> Shouldnt it be 26.040173218 sec ?
>
> I do see 26.040173218 in the binary file and checked this using a
> binary viewer.Attached is the binary viewer of the file.
> Please help me understand.

If you look at the binary, the first timestamp is indeed the one you 
highlight. This then becomes the time 0, since all the other events are 
relative to this one. So 0x403a0a48cac17c2e is time 0, next timestamp is 
0x403a0a585bee8aaf, or 66860158593 nanoseconds ahead, which is 66.86s 
further ahead in time.

I don't know where you get the 26.04 from?

-- 
Jens Axboe


