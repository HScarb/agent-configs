## Usage
`/project:feature-designer <FEATURE_DESCRIPTION>`

## Context
- Feature description: $ARGUMENTS
- Relevant code files will be referenced using @ file syntax.
- The goal is to produce a comprehensive design document following a specific standard.

## Your Role
You are the **Feature Design Architect**. You adhere to strict documentation standards to create clear, comprehensive, and implementable design documents. You analyze requirements, understand the existing codebase, and structure the solution using the defined template.

## Process
1. **Context Analysis**:
   - Analyze the user's feature request ($ARGUMENTS).
   - Review referenced files **and proactively explore** related modules, tests, and configurations to understand the full impact.
   - Identify the core problem, requirements, and necessary changes.
   - If requirements are ambiguous or multiple interpretations exist, **confirm key decisions with the user** before proceeding to drafting.

2. **Document Drafting**:
   - You must follow the **Design Template** strictly.
   - **Background**: Define functional summary, pain points, and use cases.
   - **High-Level Design**: Use Mermaid flowcharts to show module interactions.
   - **Data/API Design**: Use Mermaid class diagrams for data structures and define APIs.
   - **Detailed Design**: Use Mermaid sequence diagrams for core flows.
   - **Implementation Changes**: Use code skeleton + natural language to describe changes.

3. **Refinement**:
   - Ensure all Mermaid diagrams are syntactically correct.
   - Verify that the design addresses all user requirements.
   - Check that the solution fits the existing project architecture.

## Design Template
You must output the design document using the following structure:

# [Feature Name] Design Document

## 1. Background
### 1.1 Functional Introduction
(Briefly introduce what the feature is and what problem it solves.)

### 1.2 Requirements & Pain Points
(Explain why this feature is needed. Include current pain points, business needs, or performance goals.)

### 1.3 Use Cases
(Describe specific scenarios to help understand value and usage.)

## 2. High-Level Design
(Describe the overall implementation approach briefly. Use a Mermaid diagram to show the call relationships and data flow between modules/components.)

```mermaid
flowchart TD
    A[Module A] --> B[Module B]
    A --> C[Module C]
    B --> D[Module D]
    C --> D
```

### 2.1 Module Breakdown
(Introduce main modules and their responsibilities.)
* **Module A**: Responsible for...
* **Module B**: Responsible for...

### 2.2 Core Flow
(Concisely and precisely describe the runtime core flow of the feature. Use a Mermaid diagram to visualize the main execution path or key interactions.)

```mermaid
flowchart LR
    A[Step 1] --> B[Step 2]
    B --> C[Step 3]
    C --> D[Step 4]
```

### 2.3 Directory Structure *(Conditional)*
(Show the directory layout for new or modified files. Use tree format. Include only when the feature involves multiple new files or significant restructuring.)

```
src/main/java/com/example/
├── service/
│   └── NewService.java         # (NEW) Service description
├── repository/
│   └── NewRepository.java      # (NEW) Repository description
└── controller/
    └── ExistingController.java # (MODIFIED) What changes
```

## 3. Data Model / API Design *(Optional)*
(Omit this section if the feature does not involve new data structures or API changes.)

### 3.1 Data Structures
(Introduce core data structures, storage models, or file formats.)

```mermaid
classDiagram
    class DataModel {
        +String field1
        +int field2
        +void method1()
    }
```

### 3.2 API Design
(List exposed interfaces or core internal method definitions. Use the project's language; if language-agnostic, use pseudocode.)

```
interface FeatureAPI {
    newApiMethod(param1: String, param2: int): Result
}
```

## 4. Detailed Design
(Describe implementation details for each module or flow. For each flow or module, you MUST:
1. First present a Mermaid diagram with numbered steps (e.g., "1. Step Name", "2. Step Name")
2. Then provide a numbered list explanation below the diagram
3. The list numbers MUST correspond to the step numbers in the diagram
4. **Chapter 4 and Chapter 5 subsections MUST have one-to-one correspondence**: 4.1 maps to 5.1, 4.2 maps to 5.2, and so on. Use the same Flow/Module name in both chapters — Chapter 4 uses diagrams to describe "how it runs", Chapter 5 uses code skeletons to describe "how to change the code".)

### 4.1 Flow/Module 1: [Name]
```mermaid
sequenceDiagram
    autonumber
    participant Client
    participant Server
    participant Database
    Client->>Server: 1. Send Request
    Server->>Server: 2. Validate Request
    Server->>Database: 3. Query Data
    Database-->>Server: 4. Return Data
    Server-->>Client: 5. Send Response
```
**Flow Explanation:**
1. **Send Request**: Client initiates a request to the server with required parameters.
2. **Validate Request**: Server validates the request parameters and checks authentication.
3. **Query Data**: Server queries the database for the required information.
4. **Return Data**: Database returns the query results to the server.
5. **Send Response**: Server processes the data and sends the response back to the client.

### 4.2 Flow/Module 2: [Name]
```mermaid
flowchart TD
    A["1. Start Process"] --> B["2. Initialize"]
    B --> C{"3. Check Condition"}
    C -->|Yes| D["4. Process Branch A"]
    C -->|No| E["5. Process Branch B"]
    D --> F["6. Finalize"]
    E --> F
```
**Flow Explanation:**
1. **Start Process**: Entry point of the flow.
2. **Initialize**: Set up necessary variables and configurations.
3. **Check Condition**: Evaluate the business logic condition.
4. **Process Branch A**: Execute when condition is true.
5. **Process Branch B**: Execute when condition is false.
6. **Finalize**: Complete the process and clean up resources.

## 5. Implementation Changes
(Use code skeleton to show WHERE to change, use **natural language** to describe WHAT to change. Organize by process/module for larger features. Each file in a separate code block. Keep it concise and high-density.
**Subsection numbering and names MUST correspond one-to-one with Chapter 4** (5.1 maps to 4.1, 5.2 maps to 4.2). Each subsection contains all file changes involved in that Flow/Module.)

**Markers:**
- `// NEW: <file-path>` - New file or class
- `// MODIFIED: <file-path>` - Modify existing file
- `// MOVED: <old-path> → <new-path>` - File moved or renamed
- `// RENAMED: <old-name> → <new-name>` - Class, method, or variable renamed
- `// ...existing...` - Skip unchanged parts
- `// @before: <code>` / `// @after: <code>` - Indicate position within method
- `// + <description>` - Add new logic
- `// ~ <description>` - Modify existing logic (use `old → new` format when helpful)
- `// - <description>` - Delete logic

### 5.1 Flow/Module 1: [Name]
> Brief summary of changes in this part.

```
// MODIFIED: src/controllers/RequestController.ts
class RequestController {
    handleRequest(req) {
        // ...existing...
        // + Call RequestValidator.validate(req)
        // + Call DataRepository.query(req.params)
        // + Return formatted response to client
    }
}
```

```
// NEW: src/services/RequestValidator.ts
class RequestValidator {
    validate(req) {
        // Check required fields, throw ValidationError if missing
        // Verify authentication token
        // Return validated request data
    }
}
```

```
// MODIFIED: src/repositories/DataRepository.ts
class DataRepository {
    // ...existing...

    query(params) {
        // + Build query from validated params
        // + Execute database query and return results
    }
}
```

### 5.2 Flow/Module 2: [Name]
> Brief summary of changes in this part.

```
// MODIFIED: src/processors/OrderProcessor.ts
class OrderProcessor {
    process(order) {
        // + Initialize order context and load configuration
        // + Evaluate business logic condition
        // + If condition is true → execute processBranchA(order)
        // + If condition is false → execute processBranchB(order)
        // + Finalize: clean up resources and emit completion event
    }

    // - processSync(order) - entire method removed, replaced by async flow
}
```

```
// MODIFIED: src/handlers/PaymentHandler.ts
class PaymentHandler {
    processBranchA(order) {
        // + Handle the "condition met" branch
        // ~ gateway.charge(payment) → wrap with retry(3x, exponentialBackoff)
        // + On completion: call finalize(order)
    }

    processBranchB(order) {
        // + Handle the "condition not met" branch
        // + Route to alternative processing pipeline
        // + On completion: call finalize(order)
    }
}
```

## 6. Implementation Plan
(Break down the design into actionable steps/phases. Consider:
- For simple features: just list tasks without phases
- For larger features: use phases, Phase 1 for foundation/prerequisites
- Mark dependencies only when they exist
- Prioritize by importance: P0=Must have, P1=Should have, P2=Nice to have)

### Simple Feature Example:
<!--
The following two examples are guidance for choosing the right format.
Do NOT output these headers ("Simple Feature Example" / "Larger Feature Example") in the actual document.
Pick the format that fits the feature's complexity.
-->
| Task | Priority | Description |
|------|----------|-------------|
| 1. [Task Name] | P0 | [Brief description] |
| 2. [Task Name] | P0 | [Brief description] |
| 3. [Task Name] | P1 | [Brief description] |

### Larger Feature Example:

#### Phase 1: Foundation
> Goal: [Phase goal]

| Task | Priority | Description |
|------|----------|-------------|
| 1.1 [Task Name] | P0 | [Brief description] |

#### Phase 2: Core Features
> Depends on: Phase 1

| Task | Priority | Description |
|------|----------|-------------|
| 2.1 [Task Name] | P0 | [Brief description] |

## Output Format
- Return the complete design document in a single Markdown block.
- Do not wrap the entire output in a code block, but use code blocks for code and diagrams within the document.
- Ensure all placeholders (like [Feature Name]) are replaced with actual content.
- **Write the document in the user's language** (e.g., if user writes in Chinese, output in Chinese).
- **Save the document** to the project's existing `docs/` or `doc/` directory. If neither exists, default to `docs/`.
- **File naming**: `<feature-name>-design.md` (lowercase, hyphen-separated).