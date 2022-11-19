{
  inputs = { flake-utils.url = "github:numtide/flake-utils"; } ;
  outputs =
    { self , flake-utils } :
      flake-utils.lib.eachDefaultSystem
      (
        system :
          let
            argue =
              input-tests : output-tests : lambda : label : to-string : input :
                let
                  eval =
                    let
                      input-test-results =
                        let
                          mapper =
                            test :
                              if builtins.typeOf test != "list" then functions.error.root "test is not a list"
                              else if builtins.length test != 4 then functions.error.root "test is not a list of 4 elements"
                              else if builtins.typeOf ( builtins.elemAt test 1 ) != "bool" then functions.error.root "test does not provide success"
                              else if builtins.typeOf ( builtins.elemAt test 3 ) != "string" then functions.error.root "test does not provide result"
                              else
                                let
                                  eval = functions.apply lambda [ utils ( builtins.elemAt test 0 ) ] ;
                                  success = eval.success == builtins.elemAt test 1 ;
                                  value = if eval.value == builtins.elemAt test 2 then null else builtins.elemAt test 3 ;
                                  in { success = success ; value = [ value ] ; } ;
                          in functions.test.all input-tests mapper ;
                      output = my-fun input-test-results ( functions.apply lambda [ utils input ] ) ;
                      output-test-results =
                        let
                          mapper =
                            test :
			      if builtins.typeOf test != "list" then functions.error.root "test is not a list"
			      else if builtins.length test != 2 then functions.error.root "test is not a list of 2 elements"
			      else if builtins.typeOf ( builtins.elemAt test 0 ) != "lambda" then functions.error.root "test does not provide a criterion"
			      else if builtins.typeOf ( builtins.elemAt test 1 ) != "string" then functions.error.root "test does not provide result"
			      else
			        let
				  eval = functions.apply ( builtins.elemAt test 0 ) [ utils input output.value ] ;
				  in
				    if builtins.typeOf eval.value != "bool" then functions.error.root "test should pass or fail"
				    else if eval.success && eval.value then { success = true ; value = [ ] ; }
				    else functions.error.root ( builtins.elemAt test 1 ) ;
			  in
			    let
			      previous = output ;
			      current = functions.test.all output-tests mapper ;
			      in current ; # { success = previous.success && current.success ; value = builtins.concatLists [ previous.value current.value ] ; } ;
			string = to-string eval.output.value ;
			throw =
			  builtins.throw
			    (
			      builtins.concatStringsSep " ;\n" ( builtins.concatLists [ [ ( if builtins.typeOf label == "string" then label else "0e1964c9-5c1e-4bd0-a880-dedb50808f5f" ) ] output-test-results.value ] )
			    ) ;
			trace =
			  if ! eval.output-test-results.success then { success = false ; value = builtins.concatLists [ [ "ad562fe3-00d2-4748-a62d-5de535c54dc7" ] eval.output-tests.value ] ; }
			  else if builtins.typeOf to-string != "lambda" then { success = false ; value = [ "401d07e6-0fac-468a-8eba-beb1207a4a0d" ] ; }
			  else builtins.tryEval ( to-string eval.output.results ) ;
                      in
                        {
                          input-test-results = input-test-results ;
			  output = output ;
			  output-test-results = output-test-results ;
			  throw = throw ;
			  trace = trace ;
                        } ;
                  functions =
                    {
                      apply = lambda : arguments : builtins.foldl' reducers.apply { success = true ; value = lambda ; } arguments ;
                      error =
                        let
                          reducer = previous : current : { success = previous.success && current.success ; value = builtins.concatLists [ previous.value current.value ] ; } ;
                          root = error : { success = false ; value = [ error ] ; } ;
                          in
                            {
                              chain = previous : message : reducer previous ( root message ) ;
                              reducer = reducer ;
                              root = root ;
                            } ;
                      test =
                        {
                          all =
                            results : mapper :
                              let
                                list =
                                  if builtins.typeOf results != "list" then functions.error.root "results is not a list"
                                  else if builtins.typeOf mapper != "lambda" then functions.error.root "mapper is not a lambda"
                                  else builtins.map mapper results ;
                                in builtins.foldl' reducers.test { success = true ; value = [ ] ; } list ;
                        } ;
                    } ;
		  my-fun =
		    previous : current :
		      if ! previous.success then functions.error.chain previous "short circuiting"
		      else current ;
                  reducers =
                    {
                      apply =
                        previous : current :
                          if ! previous.success then functions.error.chain previous "short circuiting"
                          else if builtins.typeOf previous.value != "lambda" then functions.error.chain previous "not a lambda"
                          else builtins.tryEval ( previous.value current ) ;
                      test = previous : current : if current.success then previous else functions.error.reducer previous current ;
                    } ;
                  utils =
                    let
                      in
                        {
                          argue = argue ;
			  apply = functions.apply ;
                        } ;
                  in
                    {
		      output = if eval.output-test-results.success then eval.output.value else eval.throw ;
                      trace =
		        if eval.trace.success then builtins.trace eval.trace.value eval.output.value
			else if eval.out-results.success then builtins.trace eval.trace.value eval.output.value
			else eval.throw ;
                    } ;
            in { lib = argue ; }
      ) ;
}
