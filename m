Return-Path: <axboe@kernel.dk>
Subject: Re: output_format=terse,json core dumping
References: <loom.20160209T200431-709@post.gmane.org>
 <56BA4A05.7010300@kernel.dk>
 <87c43402f1e2478c8b383be5fd54eec3@AUSX13MPC107.AMER.DELL.COM>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <56BA5024.6010607@kernel.dk>
Date: Tue, 9 Feb 2016 13:46:28 -0700
MIME-Version: 1.0
In-Reply-To: <87c43402f1e2478c8b383be5fd54eec3@AUSX13MPC107.AMER.DELL.COM>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Kurt_Dorsey@Dell.com, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 02/09/2016 01:30 PM, Kurt_Dorsey@Dell.com wrote:
> *Dell - Internal Use - Confidential *
>
> Thank you Jens for the quick turn around on this!
>
> This version works much better.  The only thing is, it seems to be
> adding newline before the device field in terse (sdb) and does not
> newline after the terse and at the beginning of the json.  Very minor
> for my work and I can work around it.  I just wanted to let you know

http://git.kernel.dk/cgit/fio/commit/?id=03d189b7d77f66ce4f4dba9885d34c7a55ff4e53

-- 
Jens Axboe


