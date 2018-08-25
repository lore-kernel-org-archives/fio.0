Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] client: suppress non JSON default outputs on
 --output-format=json/json+
References: <1535128930-19580-1-git-send-email-kusumi.tomohiro@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <0449a031-45c8-ebf0-9743-98d6bf4b7d8e@kernel.dk>
Date: Fri, 24 Aug 2018 18:35:25 -0600
MIME-Version: 1.0
In-Reply-To: <1535128930-19580-1-git-send-email-kusumi.tomohiro@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 8/24/18 10:42 AM, Tomohiro Kusumi wrote:
> Suppress "hostname=...", "Disk stats (read/write)" and thread status
> if json/json+ is specified, as these are regular messages.
> 
> JSON parsers can't parse the output with these messages, and JSON
> spec doesn't support comment either.
> 
> --
>  # ./fio ./fio.cfg --output-format=json > out
>  # python3 -c "import json; json.load(open('out'))"
>  # ./fio ./fio.cfg --client=localhost --output-format=json > out
>  # python3 -c "import json; json.load(open('out'))"
>  Traceback (most recent call last):
>    File "<string>", line 1, in <module>
>    File "/usr/local/lib/python3.7/json/__init__.py", line 296, in load
>      parse_constant=parse_constant, object_pairs_hook=object_pairs_hook, **kw)
>    File "/usr/local/lib/python3.7/json/__init__.py", line 348, in loads
>      return _default_decoder.decode(s)
>    File "/usr/local/lib/python3.7/json/decoder.py", line 337, in decode
>      obj, end = self.raw_decode(s, idx=_w(s, 0).end())
>    File "/usr/local/lib/python3.7/json/decoder.py", line 355, in raw_decode
>      raise JSONDecodeError("Expecting value", s, err.value) from None
>  json.decoder.JSONDecodeError: Expecting value: line 1 column 1 (char 0)

Applied, thanks.

-- 
Jens Axboe


