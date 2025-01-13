{
  issues = {
    exclude-rules = [
      {
        path = "_test\\.go";
        linters = [
          "dupl"
          "errcheck"
          "errorlint"
          "gosec"
          "noctx"
          "nonamedreturns"
        ];
      }
      {
        path = "_test\\.go";
        linters = ["revive"];
        text = "context-keys-type|nested-structs|unchecked-type-assertion";
      }
      {
        path = "_test\\.go";
        linters = ["staticcheck"];
        text = "SA1029";
      }
    ];
    exclude-use-default = false;
    max-issues-per-linter = 0;
    max-same-issues = 0;
  };

  linters-settings = {
    depguard = {
      rules = {
        all = {
          deny = [
            {
              pkg = "reflect";
              desc = "by default reflect import is prohibited due to the high level of complexity it brings into the code";
            }
            {
              pkg = "github.com/pkg/errors";
              desc = "use go1.13 errors";
            }
          ];
          test = {
            files = ["$test"];
            deny = [
              {
                pkg = "github.com/stretchr/testify";
                desc = "testing should be done using gotest.tools/v3/assert";
              }
            ];
          };
        };
      };
    };

    errcheck = {
      check-blank = true;
      exclude-functions = [
        "io.ReadAll"
        "(io.ReadCloser).Close"
        "encoding/json.Marshal"
        "encoding/json.MarshalIndent"
        "fmt.Fprintf"
      ];
    };
    errchkjson = {
      check-error-free-encoding = true;
      report-no-exported = true;
    };
    errorlint = {
      errorf = false;
    };
    gci = {
      custom-order = true;
      sections = [
        "standard"
        "default"
        "prefix(github.com/krostar/"
        "dot"
      ];
    };
    goconst = {
      ignore-tests = true;
    };
    gocritic = {
      disabled-checks = ["ifElseChain"];
    };
    godot = {
      capital = true;
      period = true;
      scope = "toplevel";
    };
    gofumpt = {
      extra-rules = true;
    };
    govet = {
      disable = ["fieldalignment"];
      enable-all = true;
    };
    grouper = {
      import-require-single-import = true;
    };
    importas = {
      alias = [
        {
          pkg = "github.com/google/go-cmp/cmp";
          alias = "gocmp";
        }
        {
          pkg = "github.com/google/go-cmp/cmp/cmpopts";
          alias = "gocmpopts";
        }
      ];
      no-extra-aliases = true;
    };
    misspell = {
      locale = "US";
    };
    nolintlint = {
      require-explanation = true;
      require-specific = true;
    };
    reassign = {
      patterns = [".*"];
    };
    revive = {
      enable-all-rules = true;
      rules = [
        {
          name = "add-constant";
          disabled = true;
        }
        {
          name = "banned-characters";
          disabled = true;
        }
        {
          name = "cognitive-complexity";
          disabled = true;
        }
        {
          name = "cyclomatic";
          disabled = true;
        }
        {
          name = "file-header";
          disabled = true;
        }
        {
          name = "flag-parameter";
          disabled = true;
        }
        {
          name = "function-length";
          disabled = true;
        }
        {
          name = "line-length-limit";
          disabled = true;
        }
        {
          name = "max-public-structs";
          disabled = true;
        }
        {
          name = "package-comments";
          disabled = true;
        }
        {
          name = "argument-limit";
          disabled = true;
        }
        {
          name = "defer";
          arguments = [["call-chain" "loop" "recover" "immediate-recover" "return"]];
        }
        {
          name = "function-result-limit";
          arguments = [3];
        }
      ];
    };
    stylecheck = {
      checks = ["all" "-ST1000" "ST1020" "ST1021" "ST1022"];
    };
    tagliatelle = {
      case = {
        rules = {
          json = "snake";
          yaml = "kebab";
        };
      };
    };
    whitespace = {
      multi-func = true;
    };
  };

  linters = {
    enable-all = true;
    disable = [
      "bodyclose"
      "cyclop"
      "decorder"
      "dogsled"
      "err113"
      "exhaustruct"
      "exportloopref"
      "forbidigo"
      "forcetypeassert"
      "funlen"
      "ginkgolinter"
      "gocognit"
      "gocyclo"
      "goheader"
      "ireturn"
      "lll"
      "loggercheck"
      "maintidx"
      "makezero"
      "mnd"
      "nlreturn"
      "paralleltest"
      "prealloc"
      "promlinter"
      "testpackage"
      "thelper"
      "tparallel"
      "varnamelen"
      "wrapcheck"
      "wsl"
      "zerologlint"
    ];
  };
}
