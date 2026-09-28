I am setting up my OpenCode AI coding assistant configuration which utilizes three distinct agents. I will provide you with a JSON list of currently available models. Your task is to analyze the list and select the most appropriate models for each agent based on their specific roles.

Here is the context for how my OpenCode environment is organized:
1. **Plan Agent**: This is the architectural planning mode. It acts as a senior software architect. It needs the most powerful, high-reasoning, and capable model available (e.g., look for "pro", "max", or heavy reasoning models). It outlines system structures and task breakdowns but does not edit code. 
2. **Build Agent**: This is the implementation mode. It needs a highly capable coding model that balances intelligence with speed to write code, execute the plan, and fix bugs autonomously (e.g., look for "code", "plus", or solid standard tier models).
3. **Chat Agent**: This is the conversational pair-programming assistant. It is used for brainstorming and discussing logic. It needs to be very fast and responsive (e.g., look for "flash", "omni", or lower-latency models). It does not edit code.

Selection Criteria:
For each agent, you must select TWO models from the provided JSON list based on price and performance capability:
- A primary premium model (more expensive, highest performance for the tier).
- A secondary cost-effective alternative (cheaper, faster fallback).

Output Requirements:
You must output the final selection strictly in the exact format below. After you can include other text like explanations for the choice.

opencode_plan_model: "<premium_model_id>" # "<cheaper_model_id>"
opencode_build_model: "<premium_model_id>" #"<cheaper_model_id>"
opencode_chat_model: "<premium_model_id>" #"<cheaper_model_id>"