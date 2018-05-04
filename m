Return-Path: <fio-owner@vger.kernel.org>
Received: from esa2.dell-outbound.iphmx.com ([68.232.149.220]:27111 "EHLO
        esa2.dell-outbound.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751702AbeEDVZw (ORCPT
        <rfc822;fio@vger.kernel.org>); Fri, 4 May 2018 17:25:52 -0400
Subject: Re: [PATCH v2] make fio scripts python3-ready
References: <20180504143449.31934-1-billodo@redhat.com>
 <20180504194340.1835-1-billodo@redhat.com>
From: Mikhail Terekhov <Mikhail.Terekhov@dell.com>
Message-ID: <5bb7266c-a0e7-42a3-45b8-29cc916ab817@dell.com>
Date: Fri, 4 May 2018 17:25:39 -0400
MIME-Version: 1.0
In-Reply-To: <20180504194340.1835-1-billodo@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bill O'Donnell <billodo@redhat.com>, fio@vger.kernel.org

Hi,

On 05/04/18 15:43, Bill O'Donnell wrote:
> Many distributions are moving to python3 by default.  Here's
> an attempt to make the python scripts in fio python3-ready.
>
> Conversion was facilitated with automated tools. A few areas
> were hand fixed: remove superfluous parentheses introduced by
> 2to3 converter in print function calls, shebang modifications
> to use environment variable for python version, and byte-string
> decode correction in steadystate_tests.py following 2to3
> conversion.
>
> The modified scripts pass rudimentary testing when run under
> python2.7 as well as python3.
>
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> ---
> v2: Remove unnecessary changes to fiologparser_hist.py as
>     its conversion has been covered in earlier patches.
>     Keep shebangs at previous python2.7 state. Remove
>     superfluous imports.
>
>
>  doc/conf.py                     |  3 +++
>  tools/fiologparser.py           |  3 +++
>  unit_tests/steadystate_tests.py | 20 ++++++++++++--------
>  3 files changed, 18 insertions(+), 8 deletions(-)
>
> diff --git a/doc/conf.py b/doc/conf.py
> index d4dd9d20..087a9a11 100644
> --- a/doc/conf.py
> +++ b/doc/conf.py
> @@ -22,6 +22,9 @@
>  
>  # -- General configuration ------------------------------------------------
>  
> +from __future__ import absolute_import
> +from __future__ import print_function
> +
IMHO these imports are needed only for python < 2.7.
I do not think it worth it to support such an ancient versions.
The same for the other files.

>  # If your documentation needs a minimal Sphinx version, state it here.
>  #
>  # needs_sphinx = '1.0'
> diff --git a/tools/fiologparser.py b/tools/fiologparser.py
> index 8549859f..cc29f1c7 100755
> --- a/tools/fiologparser.py
> +++ b/tools/fiologparser.py
> @@ -1,4 +1,5 @@
>  #!/usr/bin/python2.7
> +# Note: this script is python2 and python 3 compatible.
>  #
>  # fiologparser.py
>  #
> @@ -13,6 +14,8 @@
>  #
>  # to see per-interval average completion latency.
>  
> +from __future__ import absolute_import
> +from __future__ import print_function
>  import argparse
>  import math
>  
> diff --git a/unit_tests/steadystate_tests.py b/unit_tests/steadystate_tests.py
> index 5a74f956..50254dcc 100755
> --- a/unit_tests/steadystate_tests.py
> +++ b/unit_tests/steadystate_tests.py
> @@ -1,4 +1,5 @@
>  #!/usr/bin/python2.7
> +# Note: this script is python2 and python 3 compatible.
>  #
>  # steadystate_tests.py
>  #
> @@ -18,6 +19,8 @@
>  # if ss attained: min runtime = ss_dur + ss_ramp
>  # if not attained: runtime = timeout
>  
> +from __future__ import absolute_import
> +from __future__ import print_function
>  import os
>  import sys
>  import json
> @@ -26,11 +29,12 @@ import pprint
>  import argparse
>  import subprocess
>  from scipy import stats
> +from six.moves import range
>  
>  def parse_args():
>      parser = argparse.ArgumentParser()
>      parser.add_argument('fio',
> -                        help='path to fio executable');
> +                        help='path to fio executable')
>      parser.add_argument('--read',
>                          help='target for read testing')
>      parser.add_argument('--write',
> @@ -45,7 +49,7 @@ def check(data, iops, slope, pct, limit, dur, criterion):
>      data = data[measurement]
>      mean = sum(data) / len(data)
>      if slope:
> -        x = range(len(data))
> +        x = list(range(len(data)))
>          m, intercept, r_value, p_value, std_err = stats.linregress(x,data)
>          m = abs(m)
>          if pct:
> @@ -89,11 +93,11 @@ if __name__ == '__main__':
>                    'output': "set steady state BW threshold to 12" },
>                ]
>      for test in parsing:
> -        output = subprocess.check_output([args.fio] + test['args']);
> -        if test['output'] in output:
> -            print "PASSED '{0}' found with arguments {1}".format(test['output'], test['args'])
> +        output = subprocess.check_output([args.fio] + test['args'])
> +        if test['output'] in output.decode():
> +            print("PASSED '{0}' found with arguments {1}".format(test['output'], test['args']))
>          else:
> -            print "FAILED '{0}' NOT found with arguments {1}".format(test['output'], test['args'])
> +            print("FAILED '{0}' NOT found with arguments {1}".format(test['output'], test['args']))
>  
>  #
>  # test some read workloads
> @@ -117,7 +121,7 @@ if __name__ == '__main__':
>              args.read = '/dev/zero'
>              extra = [ "--size=134217728" ]  # 128 MiB
>          else:
> -            print "ERROR: file for read testing must be specified on non-posix systems"
> +            print("ERROR: file for read testing must be specified on non-posix systems")
>              sys.exit(1)
>      else:
>          extra = []
> @@ -216,7 +220,7 @@ if __name__ == '__main__':
>                  else:
>                      result = 'FAILED '
>                  line = result + line + ' no ss, expected runtime {0} ~= actual runtime {1}'.format(expected, actual)
> -            print line
> +            print(line)
>              if 'steadystate' in jsonjob:
>                  pp.pprint(jsonjob['steadystate'])
>          jobnum += 1
Regards,
Mikhail
