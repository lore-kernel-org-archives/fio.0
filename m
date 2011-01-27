Message-ID: <4D41DFA4.4000708@fusionio.com>
Date: Thu, 27 Jan 2011 22:12:04 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: Recent changes
References: <20110125050003.F378B37A302@kernel.dk> <4D41DEEA.8040608@austin.ibm.com>
In-Reply-To: <4D41DEEA.8040608@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Steven Pratt <slpratt@austin.ibm.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2011-01-27 22:08, Steven Pratt wrote:
> On 01/24/2011 11:00 PM, Jens Axboe wrote:
>> The following changes since commit b8d42b234f70ce2927e9ef1279aff42d62779cfd:
>>
>>   Fio 1.50-rc4 (2011-01-20 10:17:35 -0700)
>>
>> are available in the git repository at:
>>   git://git.kernel.dk/fio.git master
>>
>> Bruce Cran (1):
>>       Unify makefiles
>>
>> Jens Axboe (3):
>>       Ensure that we exit with non-zero status on IO engine load failure
>>       mmap: catch invalid msync() errors early
>>       Remove flist_sort(), it's no longer used
>>
>>  Makefile         |   53 ++++++++++++++++----
> 
> Jens, the nested else ifeq statements in the main Makfile blow up on
> make versions prior to 3.81.  SLES10 still has 3.80.  Not a big deal
> for me, but I work with some folks for which this is over their heads.
> Any chance we could revert back to a more compatible syntax?

Oops, thanks for letting me know. I'll revert that one for now.

-- 
Jens Axboe


