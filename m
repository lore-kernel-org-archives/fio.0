Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 1/8] ignore directory= if the given path is absolute
References: <20170623220801.38178-1-tkusumi@tuxera.com>
 <20170623220801.38178-2-tkusumi@tuxera.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <9cca62e1-d3c1-8112-9bea-58ece11bcd2d@kernel.dk>
Date: Fri, 23 Jun 2017 16:16:35 -0600
MIME-Version: 1.0
In-Reply-To: <20170623220801.38178-2-tkusumi@tuxera.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: kusumi.tomohiro@gmail.com, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On 06/23/2017 04:07 PM, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> When filename= is specified in absolute path format (starts with '/'),
> being able to use directory= doesn't make much sense and also likely
> to result in an unexpected error, thus it should be ignored if any.
> 
> (If combining directory= and absolute filename= is a feature rather
> than unexpected, then it should be documented, since it works as long
> as directory/filename doesn't contain invalid directory. For example,
> directory=. and filename=/tmp/xxx work as ./tmp/xxx if ./tmp exists
> as shown in below.)
> 
> Not sure about the proper way to handle this on Windows, so I had to
> add WIN32 guard.

Honestly, I'd rather just keep it as a strict concatenation of
directory+filename. People could have valid jobs or scripts that
already do variants of

directory=/some_dir
filename=/file_in_some_dir

and it works fine. Your example above is a bit contrived, in my
opinion. If anything, we should improve the error so it shows
the file name fio attempted to use.

-- 
Jens Axboe


