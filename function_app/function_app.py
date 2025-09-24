import logging
import azure.functions as func

app = func.FunctionApp()

@app.function_name(name="HttpTrigger")
@app.route(route="ping")
def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Function received a request.')
    return func.HttpResponse("pong from IronSignal!", status_code=200)
